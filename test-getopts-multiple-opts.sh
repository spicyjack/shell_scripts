#!/bin/sh

# script to test/handle multiple calls of the same getopt switch
#
# usage:
# test-getopts-multiple-opts.sh --base base1 --base base2

GETOPT_CMD=$(/usr/bin/getopt --options b: \
    --long base: -n "test-getopts-multiple-opts.sh" -- "$@")

eval set -- "${GETOPT_CMD}"

while true;
do
    case "$1" in
        -b|--base)
            # if $BASE is not empty
            if [ "x${BASE}" != "x" ]; then
                BASE="${BASE}:$2"
            else
                # otherwise
                BASE=$2
            fi
            shift 2
            echo "BASE is now ${BASE}"
            ;;
        --) shift
            # everything after here should be a filelist file,
            # directory names or package names
            break
            ;;
        *)
            echo "ERROR: unknown option: '${1}'"
            exit 1
            ;;
    esac
done

echo "After getopts call, BASE is now ${BASE}"
