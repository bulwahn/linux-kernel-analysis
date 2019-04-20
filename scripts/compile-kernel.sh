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
	echo "  ./compile-kernel.sh <repository> <compiler/tool> <config>"
	echo
	echo "    <repository> = torvalds | stable | next"
	echo "    <compiler/tool> = gcc | clang | coccinelle | sparse"
	echo "  For gcc, clang and sparse, also provide:"
	echo "    <config> = allnoconfig | allmodconfig | allyesconfig | defconfig | randconfig"
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
# TODO: could also be two now or three.
#
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

# Check second argument and set COMPILER

case "$2" in
	gcc | clang | coccinelle )
		COMPILER=$2
		;;
	sparse )
		COMPILER=gcc
		CHECKER='C=2 CHECK="sparse"'
		;;
	*)
		echo "Error: Invalid compiler/tool: $2"
		echo 'The compiler must be either "gcc" or "clang", "coccinelle"'
		exit 1
		;;
esac

# Check third argument and set KERNEL_CONFIG

# TODO: coccinelle runs independent of the config

if [ "$COMPILER" = "coccinelle" ]; then
	if [ "$#" -ne 2 ]; then
	        echo "Error: Wrong number of arguments"
		echo "In case of coccinelle, script must be called with two arguments"
		usage
		exit 1
	fi
else
	case "$3" in
		allnoconfig | allmodconfig | allyesconfig | defconfig | tinyconfig | randconfig)
			KERNEL_CONFIG=$3
			;;
		tinydefconfig)
			# tinydefconfig does not really exist
			KERNEL_CONFIG="defconfig tiny.config"
			;;
		*)
			echo "Error: Invalid kernel config: $3"
			echo 'The kernel config must be either "allnoconfig", "allmodconfig", "allyesconfig", "defconfig", "tinyconfig" or "randconfig"'
			exit 1
			;;
	esac
fi

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
				su -p $USER_NAME -c 'make CC=clang-7 clean && make HOSTCC=clang-7 CC=clang-7 $KERNEL_CONFIG && \
					make -j1 HOSTCC=clang-7 CC=clang-7 CFLAGS_KERNEL="-Wthread-safety"' 2>&1 > /dev/null"
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
