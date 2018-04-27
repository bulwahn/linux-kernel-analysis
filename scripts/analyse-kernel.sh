#!/bin/bash

help() {
	echo "Usage: $0 [-r] [-c] [-i]"
	echo "Or you can directly provide a analysisconfig file with [--configfile]"
	echo "  -r,  kernel-repository"
	echo "  -c,  kernel-configuration"
	echo "  optional -i,  inferconfig-file location"
	echo "  --configfile, analysisconfig file for build"
	echo "  --no-analyze, don't run infer analyze after infer capture finishes"
	echo "Example: $0 -r stable -c defconfig -i [absolute-path-to-file]"
	echo "Example with analysisconfig file: $0 --configfile files/analysisconfig"
	echo "$0 --configfile [full-path-to-file] example: ./analysisconfig --configfile /home/x/y/z/analysisconfig"
	echo "Before use it, please be sure you set KERNEL_SRC_BASE variable correctly"
	exit 1
}
set_kernel_repository() {
	if [ ! -z "$1" ]; then
		case $1 in
			torvalds | stable | next )
			if [ "$1" == "torvalds" ]; then
				KERNEL_REPOSITORY="$KERNEL_SRC_BASE/torvalds/linux"
			elif [ "$1" == "stable" ]; then
				KERNEL_REPOSITORY="$KERNEL_SRC_BASE/stable/linux-stable"
			elif [ "$1" == "next" ]; then
				KERNEL_REPOSITORY="$KERNEL_SRC_BASE/next/linux-next"
			else
				echo "Invalid Kernel Repository Parameter!"
				echo "You can pass -> torvalds | stable | next"
				exit 1;
			fi
		esac
	else
		echo "You provided an empty KERNEL_REPOSITORY parameter!"
		echo "Acceptable parameters are =  torvalds | stable | next"
		exit 1;
	fi
}
set_kernel_config() {
	if [ ! -z "$1" ]; then
		case $1 in
			allnoconfig | allmodconfig | allyesconfig | defconfig | randconfig )
			KERNEL_CONFIG="$1"
			;;
	*)
		echo "You provided a KERNEL_CONFIG parameter but it is not valid!"
		echo "Valid Parameters are = allnoconfig | allmodconfig | allyesconfig | defconfig | randconfig"
		exit 1;
	esac
	else
		echo "You provided an empty KERNEL_CONFIG parameter" ##Can it happen in practice??
		echo "Valid Parameters are = allnoconfig | allmodconfig | allyesconfig | defconfig | randconfig"
		exit 1;
	fi
}
set_inferconfig_file_location() {
	if [ -f "$SCRIPTS_DIRECTORY/$1" ]; then
		INFERCONFIG_LOCATION="$SCRIPTS_DIRECTORY/$1"
	elif [ -f "$1" ]; then
		INFERCONFIG_LOCATION="$1"
	fi
}
set_scripts_directory() {
	SCRIPTS_DIRECTORY="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
}
set_analyze() {
	RUN_ANALYZE=1
}
finalize_command() {
	if [ "$RUN_ANALYZE" == "1" ]; then
		RUN_COMMAND=${RUN_COMMAND/" && infer analyze"}
	fi
}
read_and_set_variables_from_analysisconfig() {
	if [ -f "$1" ]; then
		source $1
	else
		echo "Couldn't read analysisconfig file!"
		exit 1;
	fi
}
check_kernel_src_base_valid() {
	if [ -z "$KERNEL_SRC_BASE" ]; then 
		echo "Please set KERNEL_SRC_BASE first"
		help
		exit 1
	elif [ ! -d "$KERNEL_SRC_BASE" ]; then
		echo "KERNEL_SRC_BASE does not point to a directory"
		help
		exit 1
	fi
}
check_kernel_repository_valid() {
	if [ -z "$KERNEL_REPOSITORY" ]; then
		echo "You must provide a target kernel repository"
		echo "Valid parameters are =  torvalds | stable | next"
		exit 1;
	elif [ ! -d "$KERNEL_REPOSITORY" ]; then # Check KERNEL_REPOSITORY is a directory or not
		echo "Path $KERNEL_REPOSITORY doesn't point to a directory"
		echo "Please fix it and then run script"
		exit 1
	fi
}
check_kernel_configuration_valid() {
	if [ -z "$KERNEL_CONFIG" ]; then # Check KERNEL_CONFIG variable is set
		echo "You must provide a valid kernel configuration"
		echo "Valid Parameters are = allnoconfig | allmodconfig | allyesconfig | defconfig | randconfig"
		exit 1;
	fi
}
check_inferconfig_exists() {
	#Infer always start looking from root of target file directory to find an .inferconfig file, I am not sure we can give it as a parameter???
	if [ -z "$INFERCONFIG_LOCATION" ] && [ ! -f "$KERNEL_REPOSITORY/.inferconfig" ]; then 
		echo "You should have a .inferconfig file in the root of linux-source repository"
		echo "Or you must provide a valid .inferconfig file path with -i parameter"
		exit 1;
	elif [ ! -z "$INFERCONFIG_LOCATION" ]; then
		cp "$INFERCONFIG_LOCATION" "$KERNEL_REPOSITORY/.inferconfig"
	else
		echo "Script will use .inferconfig file , that exists in $KERNEL_REPOSITORY!"
	fi
}
can_apply_patch() {
	APPLY_RESULT=$(git apply "$SCRIPTS_DIRECTORY/files/0001-Set-default-CC-to-Clang-from-Makefile.patch" 2>&1 )
	if [ -n "$APPLY_RESULT" ]; then
		echo "$APPLY_RESULT"
		echo "Failed to Apply 0001-Set-default-CC-to-Clang patch."
		echo "Please check your linux source directory"
		exit 1;
	fi
}
revert_changes_on_makefile() {
	git apply -R "$SCRIPTS_DIRECTORY/files/0001-Set-default-CC-to-Clang-from-Makefile.patch"
}
does_user_need_help() {
	if [[ "$1" == "-h" || "$1" == "--help" ]]; then
		help
		exit 0
	fi
}
## MAIN ##
# Check KERNEL_SRC_BASE
check_kernel_src_base_valid
set_scripts_directory
does_user_need_help "$1"
# Get Parameters, validate them, assign them variables.
while [[ "$#" > 0 ]]; do case $1 in
  -r) set_kernel_repository "$2"; shift; shift;;
  -c) set_kernel_config "$2"; shift; shift;;
  -i) set_inferconfig_file_location "$2"; shift; shift;;
  --configfile) read_and_set_variables_from_analysisconfig "$2"; shift; shift;;
  --no-analyze) set_analyze "$2"; shift; shift;;
  *) help; shift; shift; exit 1;;
esac; done
RUN_COMMAND="cd linux && make clean && make $KERNEL_CONFIG && infer capture -- make -j40 && infer analyze"
# Check KERNEL_REPOSITORY variable is set
check_kernel_repository_valid
check_kernel_configuration_valid
check_inferconfig_exists
finalize_command
cd $KERNEL_REPOSITORY
if [ ! -z "$KERNEL_HEAD_SHA" ]; then
	git checkout $KERNEL_HEAD_SHA
fi
can_apply_patch
DOCKER_NAME="kernel-analysis"
docker run -v "$KERNEL_REPOSITORY:/linux/" --interactive --tty $DOCKER_NAME \
/bin/sh -c "$RUN_COMMAND"
revert_changes_on_makefile
