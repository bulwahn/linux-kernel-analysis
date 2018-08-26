#!/bin/bash
# Copyright (C) Lukas Bulwahn, BMW Car IT GmbH
# SPDX-License-Identifier: GPL-2.0
#
# Compiles different branches of the kernel in a Docker container
# with a given standard kernel configuration and compiler
#

# Provide minimal help

usage() {
	echo "Usage:"
	echo "  ./compile-kernel.sh <repository> <config> <compiler> <checker>"
	echo
        echo "    <repository> = torvalds | stable | next"
	echo "    <config> = allnoconfig | allmodconfig | allyesconfig | defconfig | randconfig"
	echo "    <compiler> = gcc | clang | coccinelle"
	echo "    <checker> = sparse (optional)"
}

# Provide help if requested

if [[ "$1" == "-h" || "$1" == "--help" ]]; then
	usage
	exit 0
fi

# Check if KERNEL_SRC_BASE is set and directory exists

if [ -z "$KERNEL_SRC_BASE" ]; then
        echo "Error: KERNEL_SRC_BASE is not set"
        echo "Set the env variable KERNEL_SRC_BASE (see also: Documentation/Setup.md)"
        exit 1
fi

if [ ! -d "$KERNEL_SRC_BASE" ]; then
        echo "Error: KERNEL_SRC_BASE does not point to an existing directory"
        echo "Check the env variable KERNEL_SRC_BASE"
        exit 1
fi

# Check if script is called with three arguments

if [ "$#" -lt 3 ]; then
	echo "Error: Wrong number of arguments"
	echo "Script must be called with at least three arguments"
	usage
	exit 1
fi

# Check first argument and set KERNEL_SRC_DIR

case "$1" in
	torvalds)
		KERNEL_SRC_DIR_EXTENSION=torvalds/linux
		;;
	stable)
		KERNEL_SRC_DIR_EXTENSION=stable/linux-stable
		;;
	next)
		KERNEL_SRC_DIR_EXTENSION=next/linux-next
		;;
	*)
		echo "Error: Invalid repository: $1"
		echo 'The repository must be either "torvalds", "stable" or "next"'
		exit 1
		;;
esac
KERNEL_SRC_DIR=$KERNEL_SRC_BASE/$KERNEL_SRC_DIR_EXTENSION

# Check second argument and set KERNEL_CONFIG

case "$2" in
	allnoconfig | allmodconfig | allyesconfig | defconfig | randconfig)
		KERNEL_CONFIG=$2
		;;
	*)
		echo "Error: Invalid kernel config: $2"
		echo 'The kernel config must be either "allnoconfig", "allmodconfig", "allyesconfig", "defconfig" or "randconfig"'
		exit 1
		;;
esac

# Check third argument and set COMPILER

case "$3" in
	gcc | clang | coccinelle )
		COMPILER=$3
		;;
	*)
		echo "Error: Invalid compiler: $3"
		echo 'The compiler must be either "gcc" or "clang", "coccinelle"'
		exit 1
		;;
esac

case "$4" in
	sparse )
		CHECKER='C=2 CHECK="sparse"'
		;;
esac

# Start docker container and run build command

USER_ID=$(id -u)
GROUP_ID=$(id -g)
USER_NAME=$(whoami)
GROUP_NAME=$(id -g -n $USER_NAME)

case "$COMPILER" in
	gcc)
		docker run \
			--rm \
			-v "$KERNEL_SRC_DIR:/linux/" \
			kernel-gcc \
			/bin/sh -c "cd linux && \
				groupadd --gid $GROUP_ID $GROUP_NAME && \
				adduser --quiet --uid $USER_ID --gid $GROUP_ID --disabled-password --no-create-home --gecos '' $USER_NAME && \
				su -p $USER_NAME -c 'make clean && make $KERNEL_CONFIG && make -j$(nproc) $CHECKER'"
		;;
	clang)
		docker run \
			--rm \
			-v "$KERNEL_SRC_DIR:/linux/" \
			kernel-clang \
			/bin/sh -c "cd linux && \
				groupadd --gid $GROUP_ID $GROUP_NAME && \
				adduser --quiet --uid $USER_ID --gid $GROUP_ID --disabled-password --no-create-home --gecos '' $USER_NAME && \
				su -p $USER_NAME -c 'make CC=clang-5.0 clean && make HOSTCC=clang-5.0 CC=clang-5.0 $KERNEL_CONFIG && \
					make -j$(nproc) HOSTCC=clang-5.0 CC=clang-5.0 $CHECKER'"
		;;
	coccinelle)
		docker run \
			--rm \
			-v "$KERNEL_SRC_DIR:/linux/" \
			kernel-coccinelle \
			/bin/sh -c "cd linux && \
				groupadd --gid $GROUP_ID $GROUP_NAME && \
                                adduser --quiet --uid $USER_ID --gid $GROUP_ID --disabled-password --no-create-home --gecos '' $USER_NAME && \
                                su -p $USER_NAME -c 'make clean && rm -f all.err && \
					make coccicheck MODE=report DEBUG_FILE=all.err V=1'"
		;;
esac
