#!/bin/sh
# other possible choices here are /bin/bash or maybe /bin/ksh

# $Id: openpdfdir.sh,v 1.3 2004-12-12 02:13:17 brian Exp $
# Copyright (c)2004 by Brian Manning
#
# shell script that opens a directory of (pdf|PDF)'s and then runs xpdf to
# verify the file can be read (was a good download)

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

# where's your PDF reader?
PDFREADER="/usr/bin/xpdf"
if [ ! -x ${PDFREADER} ]; then 
    echo "Hmm.  Looks like your PDF reader doesn't exist or "
    echo "it's not set to be executable.  You'll need to fix that..."
fi # if [ ! -x ${PDFREADER} ]

# BSD's getopt is simpler than the GNU getopt; we need to detect it 
if [ -x /bin/uname ]; then
    OSDETECT=$(/bin/uname -s)
elif [ -x /usr/bin/uname ]; then
    OSDETECT=$(/usr/bin/uname -s)
fi 

if [ ${OSDETECT} == "Darwin" ]; then 
    # this is the BSD part
    echo "WARNING: BSD OS Detected; long switches will not work here..."
    TEMP=$(/usr/bin/getopt dhnc:m: $*)
elif [ ${OSDETECT} == "Linux" ]; then
    # and this is the GNU part
    TEMP=$(/usr/bin/getopt -o dhnc:m: \
	    --long debug,help,noprompt,changedir:,movedir: -n \
        'openpdfdir.sh' -- "$@")
else
    echo "Error: Unknown OS Type.  I don't know how to call"
    echo "'getopts' correctly for this operating system.  Exiting..."
    exit 1
fi 

# if there's no options passed in, then exit with error 1
#if [ $? != 0 ] ; then 
#    echo "Nothing to do, exiting..." >&2 ; exit 1 ; 
#fi

# Note the quotes around `$TEMP': they are essential!
# read in the $TEMP variable
eval set -- "$TEMP"

# set $VERBOSE, and if --quiet is called it will get unset
VERBOSE=1

# read in command line options and set appropriate environment variables
# if you change the below switches to somethign else, make sure you change the
# getopts call above
while true ; do
	case "$1" in
		-h|--help) 
		echo "cvs_sync.sh:"
        echo "[-d|--debug]:     Show debugging info as the script runs"
        echo "[-h|--help]:      Show this help output"
        echo "[-c|--changedir]: Change to this directory before running"
        echo "[-m|--movedir]:   Move the file to this directory after checking"
        echo "[-n|--noprompt]:  Don't prompt on file deletes"
		echo "NOTE: Long switches do not work with BSD systems"; 
		exit 1;;
		-d|--debug)		    DEBUG=1; shift;;
		-n|--noprompt)		NOPROMPT=1; shift;;
		-c|--changedir) 	CHANGEDIR=$2; shift 2;;
		-m|--movedir)   	
            MOVEDIR=$2
            shift 2
            if [ ! -w ${MOVEDIR} ]; then
                echo "ERROR: can't write to ${MOVEDIR}"
                exit 1
            fi 
            ;;
		--) shift; break;;
	esac
done
#	-q|--quiet) 	    unset -v $VERBOSE; shift;;

# FIXME add the changedir code here
# read in the list of PDF files
PDF_FILES=`ls *.[Pp][Dd][Ff]`
COUNTER=0
IFS=$'\t\n'

if [ $DEBUG ]; then
    echo "Debug: PDF_FILES is >$PDF_FILES<"
fi

# parse the PDF_FILES variable
for FILE in ${PDF_FILES}; do
    COUNTER=`expr ${COUNTER} + 1`
    echo "Running \$PDF_READER on file # ${COUNTER}"
    echo "${FILE}" 
    ${PDFREADER} ${FILE}
    echo -n "[D]elete, [M]ove, [I]gnore, or [Q]uit (Default = Ignore): "
    read INJUNK
    # TODO change this to react to what the user enters
    case "$INJUNK" in
        d|D) # delete
            echo "Deleting file ${FILE}"
            if [ $NOPROMPT ]; then
                 /bin/rm ${FILE}; 
            else 
                /bin/rm -i ${FILE}; 
            fi
        ;;
        m|M) # move file
            if [ ${MOVEDIR} ]; then
                echo "Moving file ${FILE}"
                echo "to ${MOVEDIR}"
                /bin/mv -v ${FILE} ${MOVEDIR}
            else 
                echo "--movedir not specified, skipping file move"
            fi
        ;;
        q|Q) # quit
            exit 0
        *) # all other options (including [I]
        ;;
    esac
done

# vi: set sw=4 ts=4 cin:
# end of line
