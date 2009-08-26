#!/bin/bash

# syncs a list of CVS modules

# you can generate a list of directories to sync with the following command:
# find ~/cvs/ -type d -maxdepth 1 | sort

# BSD's getopt is simpler than the GNU getopt; we need to detect it 
OSDETECT=$(/usr/bin/uname -s)
if [ ${OSDETECT} == "Darwin" ]; then 
    # this is the BSD part
    echo "WARNING: BSD OS Detected; long switches will not work here..."
    TEMP=$(/usr/bin/getopt dhqf: $*)
elif [ ${OSDETECT} == "Linux" ]; then
    # and this is the GNU part
    TEMP=$(/usr/bin/getopt -o dhqf: \
	    --long debug,help,quiet,file: -n 'cvs_sync.sh' -- "$@")
else
    echo "Error: Unknown OS Type.  I don't know how to call"
    echo "'getopts' correctly for this operating system.  Exiting..."
    exit 1
fi 

# if there's no options passed in, then exit with error 1
if [ $? != 0 ] ; then 
    echo "Nothing to do, exiting..." >&2 ; exit 1 ; 
fi

# Note the quotes around `$TEMP': they are essential!
# read in the $TEMP variable
eval set -- "$TEMP"

# set $VERBOSE, and if --quiet is called it will get unset

VERBOSE=1
while true ; do
	case "$1" in
		-h|--help) 
		echo "cvs_sync.sh: [-d|-h|-f|-q] [--debug|--help|--file|--quiet]"; 
		echo "file should contain a list of directories ";
		echo "(with absolute paths from '/') to sync"; 
		echo "NOTE: Long switches do not work with BSD systems"; 
		exit 1;;
		-q|--quiet) 	unset -v $VERBOSE; shift;;
		-d|--debug)		DEBUG=1; shift;;
		-f|--file) 		PROJ_LIST=$2; shift 2;;
		--) shift; break;;
	esac
done

if [ $DEBUG ]; then
    echo "Debug: PROJ_LIST is >$PROJ_LIST<"
fi

# walk thru the list of files
for x in `cat $PROJ_LIST`; do
	# some pretty printing
    if [ $VERBOSE ]; then 
		echo "======================================================="
		echo "entering $x"
	fi # if [ $VERBOSE ]; then

	# does the directory exist?
    if [ -d $x ]; then 
		cd $x 
	else 
		echo "ERROR: $x doesn't exist; exiting..."
		exit 1
	fi # if [ -d $x ]; then

	# some more pretty printing
    if [ $VERBOSE ]; then echo "running cvs update in $x"; fi

	# are we debugging?
	if [ $DEBUG ]; then
		echo "--> simulating running 'cvs update -d'"
	else
        if [ $VERBOSE ]; then
        	/usr/bin/cvs update -d
        else 
            /usr/bin/cvs update -d 2>&1 > /dev/null
        fi # if [ $VERBOSE ]; then
	fi # if [ $DEBUG ]; then
done # for x in `cat $PROJ_LIST`; do
