#!/bin/sh
# other possible choices here are /bin/bash or maybe /bin/ksh

# $Id: awstats_update.sh,v 1.15 2007-03-28 23:35:08 brian Exp $
# Copyright (c)2005 by Brian Manning

# Run awstats.pl for one or more domains, generate the HTML output pages
# automagically

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

### SCRIPT CONFIGURATION ###
# paths to various binary files
PERL="/usr/bin/perl"
TR="/usr/bin/tr"
GREP="/bin/grep"
SED="/bin/sed"
LOGROTATE="/usr/sbin/logrotate"
SCRIPTNAME=$(basename $0)

# path to the awstats configuration files
STATS_DIR="/etc/awstats"

# set quiet mode by default, needs to be set prior to the getops call
# QUIET is a global parameter
QUIET=1

# prompt by default unless running in quiet mode
PROMPT=1

# don't rotate logs by default
ROTATE=0

# default exit status code
EXIT=0


### FUNCTIONS ###
function checkForErrors() 
{
    # check the exit status of the previously run command, display output
    ERROR=$1    # exit status of previously run command ($?)
    OUTPUT=$2  # output of previously run command

    # check for errors from the script
    if [ $ERROR -ne 0 ] ; then 
    	echo -n "${START}${MSG_DELETE}${END}command exited with error:"
        echo "${START};${NONE}${END}"
    	echo $? >&2
    	echo -n "${START}${MSG_DELETE}${END}command output:"
        echo "${START};${NONE}${END}"
        echo $OUTPUT | $TR '!' 'n/'
     	EXIT=1
    else
        if [ $QUIET -eq 0 ]; then
        	echo -n "${START}${MSG_VERBOSE}${END}command exited with no errors"
        	echo "${START};${NONE}${END}"
    	    echo -n "${START}${MSG_INFO}${END}command output:"
        	echo "${START};${NONE}${END}"
            echo $OUTPUT | $TR '!' '\n'
        fi
        EXIT=0
    fi
} # function checkForErrors

function parseLog()
{
    local CONFIG=$1 # name of awstats configuration to use

    if [ $QUIET -eq 0 ]; then
        # run the script
        echo 
        echo -n "=-=-=-=${START}${MSG_INFO}${END} "
        echo -n "Gathering Stats for '${CONFIG}' - ${MONTH_ABBR}/${YEAR} "
        echo "${START};${NONE}${END}=-=-=-="
    fi

    # FIXME change this so it writes to a file, and can be parsed with sed
    # later on.  Saving it into a shell variable strips newlines
    OUTPUT=$(/usr/bin/perl /root/bin/awstats.pl \
        -config=$CONFIG -update 2>&1 | ${TR} '\n' '!')
    #/bin/false
    # verify the previous script exited cleanly
    checkForErrors $? "$OUTPUT"
} # function parseLog()


function generateHTMLOutput()
{
    local CONFIG=$1
    if [ $QUIET -eq 0 ]; then
        # run the script
        echo 
        echo -n "=-=-=-=${START}${MSG_INFO}${END} "
        echo -n "Generating Web Pages for '${CONFIG}' - ${MONTH_ABBR}/${YEAR} "
        echo "${START};${NONE}${END}=-=-=-="
    fi

    # generate a page
    OUTPUT=$(/usr/bin/perl /root/bin/awstats_buildstaticpages.pl \
    -dir=/home/antlinux/awstats/${CONFIG} -config=${CONFIG} -year=${YEAR} \
    -awstatsprog=/root/bin/awstats.pl -month=${MONTH} \
    -builddate=${MONTH_ABBR}${YEAR} 2>&1 | ${TR} '\n' '!')
    # verify the previous script exited cleanly
    checkForErrors $? "$OUTPUT"
} # function generateHTMLOutput()

function logRotate() 
{
#local LOGFILE=$1 # file name of current config file
    local CONFIG=$2  # current configuration 
    # get the name of the current apache logfile
    # 's/^.*="\(.*\)"/\1/' means "everything between the quote marks, and
    # the grep just pulls out the line labeled "LogFile" in the config file
#    APACHELOG=$( $GREP "LogFile" $LOGFILE | $GREP -v "^#" \
#        |  $SED 's/^.*="\(.*\)"/\1/')
#    APACHELOG="/var/log/httpd/access_${CONFIG}.log"
#    ERRORLOG="/var/log/httpd/error_${CONFIG}.log"
    #ERRORLOG=$( $GREP "ErrorLog" $LOGFILE | $GREP -v "^#" \
    #        |  $SED 's/^.*="\(.*\)"/\1/')
    
    # we need to use a different binary for the below if the logs being
    # rotated are for the wiki
    if [ $CONFIG == 'oldwiki' ]; then
        APACHE_BIN='wikihttpd'
    else
        APACHE_BIN='httpd'
    fi # if [ $CONFIG == 'wiki' ]

    #tee $TEMPFILE <<-EOC 
    # from Chapter 7.1.1 of "Learning the Korn Shell" and Section 8.18 of "Unix
    # Power Tools"
    for LOGFILE in "/var/log/httpd/access_${CONFIG}.log" \
        "/var/log/httpd/error_${CONFIG}.log";
    do
        cat > $TEMPFILE <<-EOC 
        "${LOGFILE}" {
            rotate 52
            weekly
            compress
            missingok
            olddir /var/log/httpd/old
            postrotate
                /etc/init.d/${APACHE_BIN} restart
            endscript
        }
        # ${CONFIG}
EOC
    
#echo "contents of the logrotate file are:"
#cat $TEMPFILE
#echo "Logfile ends here!"
        
        echo 
        echo -n "=-=-=-=${START}${MSG_INFO}${END} "
        echo -n "Running Logrotate for ${LOGFILE} "
        echo "${START};${NONE}${END}=-=-=-="
            
        # run it; TEMPFILE is the temporary file created at the beginning of
        # this script which automagically becomes the logrotate config file
        if [ $QUIET -eq 0 ]; then
            $LOGROTATE $TEMPFILE
        else
            $LOGROTATE -v $TEMPFILE
        fi

    done # for LOGFILE in "/var/log/httpd/access_${CONFIG}.log"
} # function logRotate

function mainLoop()
{
    local LOGFILE=$1
    
    # generate the CONFIG parameter by stripping the LOGFILE for it
    # sed 's/^.*awstats\.\(.*\)\.conf$/\1/' strips the beginning and end off of
    # the filename, leaving the config to use as '\1'
    CONFIG=$(echo $LOGFILE| $SED 's/^.*awstats\.\(.*\)\.conf$/\1/')
    #echo "config is >$CONFIG<"

    # if $NOPARSELOG is set...
    if [ -z $NOPARSELOG ]; then
        parseLog $CONFIG
        # rotate logs?  logRotate wants the logfile, not the name of the
        # config 
        if [ $ROTATE -eq 1 ]; then
            logRotate $LOGFILE $CONFIG
        fi 
    fi # if [ ! -z $NOPARSELOG ]; then

    # output the logfiles
    generateHTMLOutput $CONFIG

    # exit cleanly if we reach here
    if [ $QUIET -eq 0 ]; then
        # prompt unless --noprompt is set
        if [ $PROMPT -eq 1 ]; then
            echo "Hit <ENTER> to continue"
            read ANSWER
        fi
    fi  # if [ $QUIET -eq 0 ]; then

} # function mainLoop()

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

### SCRIPT SETUP ###
# BSD's getopt is simpler than the GNU getopt; we need to detect it 
if [ -x /bin/uname ]; then
    OSDETECT=$(/bin/uname -s)
elif [ -x /usr/bin/uname ]; then
    OSDETECT=$(/usr/bin/uname -s)
else
    echo "ERROR: Can't find 'uname' program"
    exit 1;
fi # if [ -x /bin/uname ]; then

# double check the output of uname to be sure, but the above tests should give
# us a ballpark figure as to what platform we're currently on
if [ ${OSDETECT} == "Darwin" ]; then 
    # this is the BSD part
    echo "WARNING: BSD OS Detected; long switches will not work here..."
    TEMP=$(/usr/bin/getopt hc:lpqvm:ry: $*)
elif [ ${OSDETECT} == "Linux" ]; then
    # and this is the GNU part
    TEMP=$(/usr/bin/getopt -o hc:lm:pqrvy: \
	 --long help,config:,noparselog,noprompt,quiet,rotate,verbose,month:,year: \
     -n '$SCRIPTNAME' -- "$@")
else
    echo "Error: Unknown OS Type.  I don't know how to call"
    echo "'getopts' correctly for this operating system.  Exiting..."
    exit 1
fi # if [ ${OSDETECT} == "Darwin" ]; then

# if getopts exited with an error code, then exit the script
#if [ $? -ne 0 -o $# -eq 0 ] ; then
if [ $? != 0 ] ; then 
	echo "Run '$SCRIPTNAME --help' to see script options" >&2 
	exit 1
fi

# Note the quotes around `$TEMP': they are essential!
# read in the $TEMP variable
eval set -- "$TEMP"

# read in command line options and set appropriate environment variables
# if you change the below switches to something else, make sure you change the
# getopts call(s) above
ERRORLOOP=1
while true ; do
	case "$1" in
		-h|--help) # show the script options
		cat <<-EOF

	$SCRIPTNAME [options]

	SCRIPT OPTIONS
    -h|--help       Displays this help message
    -c|--config     Use this config file only (Don't do all config files)
    -v|--verbose    Nice pretty output messages
    -q|--quiet      No script output (unless an error occurs)
    -p|--noprompt   Don't prompt after each output run
    -r|--rotate     Rotate the logfile using 'logrotate'
    -m|--month      Month to use for web page generation (example: MM)
    -y|--year       Year to use for web page generation (example: YYYY)
    -l|--noparselog Only generate the webpages, don't parse logs

    NOTE: Long switches do not work with BSD systems (GNU extension)

EOF
		exit 0;;		
		-q|--quiet)	# don't output anything (unless there's an error)
						QUIET=1;
                        # set --noprompt
                        PROMPT=0;
                        ERRORLOOP=$(($ERRORLOOP - 1));
						shift;;
        -v|--verbose) # output pretty messages
                        QUIET=0; ERRORLOOP=$(($ERRORLOOP - 1));
                        shift;;
        -p|--noprompt) # don't prompt at the end of each run
                        PROMPT=0; ERRORLOOP=$(($ERRORLOOP - 1));
                        shift;;
        -r|--rotate) # rotate log files using logrotate
                        ROTATE=1; ERRORLOOP=$(($ERRORLOOP - 1));
                        shift;;
        -m|--month) # a month was passed in
                        MONTH=$2; ERRORLOOP=$(($ERRORLOOP - 1));
                        shift 2;;
        -y|--year) # a year was passed in
                        YEAR=$2; ERRORLOOP=$(($ERRORLOOP - 1));
                        shift 2;;
        -c|--config) # a year was passed in
                        CONFIG=$2; ERRORLOOP=$(($ERRORLOOP - 1));
                        shift 2;;
        -l|--noparselog) # don't parse logs
                        NOPARSELOG=1; ERRORLOOP=$(($ERRORLOOP - 1));
                        shift;;
		--) shift; break;;
	esac
	# exit if we loop across getopts too many times
	ERRORLOOP=$(($ERRORLOOP + 1))
	if [ $ERRORLOOP -gt 4 ]; then
		echo "ERROR: too many getopts passes;"
		echo "Maybe you have a getopt option with no branch?"
		exit 1
	fi # if [ $ERROR_LOOP -gt 3 ];

done

if [ $ROTATE -eq 1 ]; then 
    # create a temporary logfile
    echo 
    echo -n "=-=-=-=${START}${MSG_INFO}${END} "
    echo -n "Creating Temporary file for log rotation "
    echo "${START};${NONE}${END}=-=-=-="
    TEMPFILE=$(mktemp /tmp/logrotate.${$}.XXXXXX)
    checkForErrors $? $TEMPFILE
fi

### SCRIPT MAIN LOOP ###

# generate a numeric month and year for the web page output if the month
# and year were not passed into the script as options.
if [ -z $MONTH ]; then MONTH=$(date +%m| tr -d '\n'); fi
if [ -z $YEAR ]; then YEAR=$(date +%Y| tr -d '\n'); fi

# get an abbreviated month string based on $MONTH
# reset the month string just in case the user passed in a text string
# instead of something awstats can parse
case "${MONTH}" in
    01|1|Jan|jan)   MONTH=01;MONTH_ABBR="Jan";;
    02|2|Feb|feb)   MONTH=02;MONTH_ABBR="Feb";;
    03|3|Mar|mar)   MONTH=03;MONTH_ABBR="Mar";;
    04|4|Apr|apr)   MONTH=04;MONTH_ABBR="Apr";;
    05|5|May|may)   MONTH=05;MONTH_ABBR="May";;
    06|6|Jun|jun)   MONTH=06;MONTH_ABBR="Jun";;
    07|7|Jul|jul)   MONTH=07;MONTH_ABBR="Jul";;
    08|8|Aug|aug)   MONTH=08;MONTH_ABBR="Aug";;
    09|9|Sep|sep)   MONTH=09;MONTH_ABBR="Sep";;
    10|Oct|oct)     MONTH=10;MONTH_ABBR="Oct";;
    11|Nov|nov)     MONTH=11;MONTH_ABBR="Nov";;
    12|Dec|dec)     MONTH=12;MONTH_ABBR="Dec";;
esac

# if no awstats config file was passed in, parse all the config files
if [ -z $CONFIG ]; then 
    for LOGFILE in $( ls ${STATS_DIR}/awstats.*.conf )
    do  
        mainLoop $LOGFILE
    done # for LOGFILE in $( ls ${STATS_DIR}/awstats.*.conf )
else 
    # a config was passed in, parse this one config file only
    mainLoop $STATS_DIR/awstats.$CONFIG.conf
fi # if [ -z $CONFIG ]; then

if [ $ROTATE -eq 1 ]; then
    # remove the tempfile
    echo 
    echo -n "=-=-=-=${START}${MSG_INFO}${END} "
    echo -n "Removing Temporary file ${TEMPFILE} "
    echo "${START};${NONE}${END}=-=-=-="
    OUTPUT=$(/bin/rm -f $TEMPFILE)
    checkForErrors $? $OUTPUT
fi # if [ $ROTATE -eq 1 ]; then

# cough up the exit code
exit ${EXIT}

# vi: set sw=4 ts=4 cin:
# end of line
