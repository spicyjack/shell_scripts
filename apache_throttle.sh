#!/bin/sh

# $Id: apache_throttle.sh,v 1.3 2007-05-04 16:26:16 brian Exp $
# Copyright (c)2004 by Brian Manning
#
# shell script that does something

#   This program is free software; you can redistribute it and/or modify
#   it under the terms of the GNU General Public License as published by
#   the Free Software Foundation; version 2 dated June, 1991.
#
#   This program is distributed in the hope that it will be useful,
#   but WITHOUT ANY WARRANTY; without even the implied warranty of
#   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#   GNU General Public License for more details.
#
#   You should have received a copy of the GNU General Public License
#   along with this program;  if not, write to the Free Software
#   Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111, USA.

### FUNCTIONS ###
function check_for_errors() 
{
    ERROR=$1
    QUIET=$2
    PROGRAM=$3

    # check for errors from the script
    if [ $ERROR -ne 0 ] ; then 
        if [ $QUIET -eq 0 ]; then
    	    echo -n "${START}${MSG_DELETE}${END}${PROGRAM} exited with error:"
        	echo "${START};${NONE}${END}"
    	    echo $? >&2
        fi
     	EXIT=1
    else
        if [ $QUIET -eq 0 ]; then
        	echo -n "${START}${MSG_VERBOSE}${END}${PROGRAM}"
            echo -n " exited with no errors"
        	echo "${START};${NONE}${END}"
        fi
        EXIT=0
    fi
} # function check_for_errors

### OUTPUT COLORIZATION VARIABLES ###
START="["
END="m"

# text attributes
NONE=0; BOLD=1; NORM=2; BLINK=5; INVERSE=7; CONCEALED=8

# background colors
B_BLK=40; B_RED=41; B_GRN=42; B_YLW=43
B_BLU=44; B_MAG=45; B_CYN=46; B_WHT=47

# foreground colors
F_BLK=30; F_RED=31; F_GRN=32; F_YLW=33
F_BLU=34; F_MAG=35; F_CYN=36; F_WHT=37

# some shortcuts
MSG_DELETE="${BOLD};${F_YLW};${B_RED}"
MSG_DRYRUN="${BOLD};${F_WHT};${B_BLU}"
MSG_VERBOSE="${BOLD};${F_WHT};${B_GRN}"
MSG_INFO="${BOLD};${F_BLU};${B_WHT}"

### MAIN SCRIPT ###
# script's name
SCRIPTNAME=$(basename $0)
UNAME=$(which uname)
GETOPT=$(which getopt)

# set quiet mode by default, needs to be set prior to the getops call
QUIET=1

### SCRIPT SETUP ###
# BSD's getopt is simpler than the GNU getopt; we need to detect it 
OSDETECT=$(${UNAME} -s)
if [ ${OSDETECT} == "Darwin" ]; then 
    # this is the BSD part
    echo "WARNING: BSD OS Detected; long switches will not work here..."
    TEMP=$(${GETOPT} hdnqv $*)
elif [ ${OSDETECT} == "Linux" ]; then
    # and this is the GNU part
    TEMP=$(${GETOPT} -o hdnqv \
	    --long help,day,night,prompt,quiet,verbose \
        -n '${SCRIPTNAME}' -- "$@")
else
    echo "Error: Unknown OS Type.  I don't know how to call"
    echo "'getopts' correctly for this operating system.  Exiting..."
    exit 1
fi 

# if getopts exited with an error code, then exit the script
#if [ $? -ne 0 -o $# -eq 0 ] ; then
if [ $? != 0 ] ; then 
	echo "Run '${SCRIPTNAME} --help' to see script options" >&2 
	exit 1
fi

# Note the quotes around `$TEMP': they are essential!
# read in the $TEMP variable
eval set -- "$TEMP"

# read in command line options and set appropriate environment variables
# if you change the below switches to something else, make sure you change the
# getopts call(s) above
while true ; do
	case "$1" in
		-h|--help) # show the script options
		cat <<-EOF

	${SCRIPTNAME} [options]

    SCRIPT OPTIONS
    -h|--help       Displays this help message
    -d|--day        Set 'daytime' configuration
    -n|--night      Set 'nighttime' configuration
    -q|--quiet      Do not output any status messages (default)
    -v|--verbose    Output status messages 
    NOTE: Long switches do not work with BSD systems (GNU extension)

EOF
		exit 0;;		
		-d|--day)
		    MODE="daytime"
		    shift;;
        -n|--night) 
            MODE="nighttime"
            shift;;
        -q|--quiet) # don't output anything (unless there's an error)
            QUIET=1
            shift;;
        -v|--verbose) # output pretty messages
            QUIET=0
            shift;;
		--) shift; break;;
	esac
done

### SCRIPT MAIN LOOP ###
VIRTUAL_HOST_PATH=/etc/httpd/domains
/etc/init.d/httpd stop
check_for_errors $? $QUIET "httpd"

rm $VIRTUAL_HOST_PATH/files.conf
case "${MODE}" in
    daytime)
        /bin/ln -s $VIRTUAL_HOST_PATH/files_day.conf \
            $VIRTUAL_HOST_PATH/files.conf
        ;;
    nighttime)
        /bin/ln -s $VIRTUAL_HOST_PATH/files_night.conf \
            $VIRTUAL_HOST_PATH/files.conf
        ;;
esac

HTTPD_PROCS=1
while [ $HTTPD_PROCS -gt 0 ];
do
    HTTPD_PROCS=$(ps auxw | grep httpd | grep -v grep | wc -l)
    sleep 1
done

/etc/init.d/httpd start

# verify the previous script exited cleanly
check_for_errors $? $QUIET "httpd"

exit ${EXIT}

# vi: set ft=sh sw=4 ts=4 cin:
# end of line
