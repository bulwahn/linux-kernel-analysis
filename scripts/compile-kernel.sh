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
	echo "  ./compile-kernel.sh <repository> <config> <compiler>"
	echo
        echo "    <repository> = torvalds | stable | next"
	echo "    <config> = allnoconfig | allmodconfig | allyesconfig | defconfig | randconfig"
	echo "    <compiler> = gcc | clang-5.0 | clang-6.0 | clang-7"
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

if [ "$#" -ne 3 ]; then
	echo "Error: Wrong number of arguments"
	echo "Script must be called with three arguments"
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
	gcc | clang-5.0 | clang-6.0 | clang-7)
		COMPILER=$3
		;;
	*)
		echo "Error: Invalid compiler: $3"
		echo 'The compiler must be "gcc", "clang-5.0", "clang-6.0" or "clang-7"'
		exit 1
		;;
esac

# Start docker container and run build command

case "$COMPILER" in
	gcc)
		docker run \
			--rm \
			-v "$KERNEL_SRC_DIR:/linux/" \
			kernel-gcc \
			/bin/sh -c "cd linux && make clean && make $KERNEL_CONFIG && make -j32"
		;;
	clang-5.0 | clang-6.0 | clang-7)
		docker run \
			--rm \
			-v "$KERNEL_SRC_DIR:/linux/" \
			kernel-$COMPILER \
			/bin/sh -c "cd linux && \
				make CC=$COMPILER clean && \
				make HOSTCC=$COMPILER $KERNEL_CONFIG && \
				make -j32 HOSTCC=$COMPILER CC=$COMPILER"
		;;
esac
