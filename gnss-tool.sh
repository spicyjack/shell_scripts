#!/bin/bash

# gnss-tool.sh
# Enable the GNSS receiver on the uConsole device (SimCom SIM7600)

# Copyright (c)2024 Brian Manning <brian at xaoc dot org>
# License: Apache v2 (see licence blurb at the bottom of the file)

# - Clone the script repo with:
#   - git clone
# - Script also can be obtained from:
#   -
# - Get support and more info about this script at:
#   -

# what's my name?
SCRIPTNAME=$(basename $0)

# assume everything will go well
EXIT_STATUS=0

# set quiet mode by default, needs to be set prior to the getops call
QUIET=0

# colorize? yes please (1=yes, colorize, 0=no, don't colorize)
COLORIZE=1
# always colorize?  set via --colorize
ALWAYS_COLORIZE=0

# dry-run, i.e. show commands, don't run them? (0 = no, 1 = yes)
DRY_RUN=0

DEVICE_MODEM="/dev/ttyUSB2"
DEVICE_GNSS="/dev/ttyUSB3"

### OUTPUT COLORIZATION VARIABLES ###
START="\x1b["
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
MSG_FAIL="${BOLD};${F_YLW};${B_RED}"
MSG_WARN="${F_YLW};${B_BLK}"
MSG_DRYRUN="${BOLD};${F_CYN};${B_BLU}"
MSG_OK="${BOLD};${F_WHT};${B_GRN}"
MSG_REMOTE="${F_CYN};${B_BLK}"
MSG_INFO="${BOLD};${F_WHI};${B_BLU}"
MSG_FLUFF="${BOLD};${F_BLU};${B_BLK}"

### FUNCTIONS ###
# wrap text inside of ANSI tags, unless --nocolor is set
colorize () {
    local COLOR="$1"
    local TEXT="$2"

    if [ $COLORIZE -eq 1 ]; then
        COLORIZE_OUT="${COLORIZE_OUT}${START}${COLOR}${END}${TEXT}"
        COLORIZE_OUT="${COLORIZE_OUT}${START};${NONE}${END}"
    else
        COLORIZE_OUT="${COLORIZE_OUT}${TEXT}"
    fi
}

# clear the COLORIZE_OUT variable
colorize_clear () {
    COLORIZE_OUT=""
}

# check the exit status of a sub-process that was run
check_exit_status() {
    local ERROR=$1
    local CMD_RUN="$2"
    local CMD_OUT="$3"

    # check for errors from the script
    if [ $ERROR -ne 0 ] ; then
        if [ $QUIET -eq 0 ]; then
            colorize_clear
            colorize $MSG_FAIL "${CMD_RUN} exited with error: $ERROR"
            $ECHO_CMD $COLORIZE_OUT
            colorize_clear
            colorize $MSG_FAIL "${CMD_RUN} output: "
            $ECHO_CMD $COLORIZE_OUT
            colorize_clear
            colorize $MSG_WARN "${CMD_OUT}"
            $ECHO_CMD $COLORIZE_OUT
            colorize_clear
        fi
        EXIT_STATUS=1
    fi
} # check_exit_status

show_help() {
# show script options
cat <<-EOH

${SCRIPTNAME} [options] <command>

    GENERAL SCRIPT OPTIONS
    -h|--help       Displays this help message
    -e|--examples   Show examples of script usage
    -q|--quiet      No script output (unless an error occurs)
    -n|--dry-run    Explain what will be done, don't actually do it
    -c|--colorize   Always colorize output, ignore '-t' test

    OPTIONS FOR DIRECTORY PATHS
    -p|--path       Starting path for searching for Git repos
    -x|--exclude    Exclude these paths from the search

NOTES:
- Colorization is disabled when script outputs to pipe (-t set on filehandle)

EOH

}

gnss_fw_version () {
   echo -en "AT+CUSBPIDSWITCH?\r\n" | sudo $SOCAT_BIN - ${DEVICE_MODEM},crnl
}

gnss_start () {
   echo -en "AT+CGPS=1\r\n" | sudo $SOCAT_BIN - ${DEVICE_MODEM},crnl
}


modem_device_check () {
   CHECK_COUNT=10
   sleep 5s
   MMCLI_OUT=$(mmcli -L)
   MMCLI_AVAILABLE=$(echo MMCLI_OUT | grep -c 'SIM7600G')
   if [ $MMCLI_AVAILABLE -eq 0 ]; then
      echo "ERROR: modem not available"
      exit 1
   fi
}

modem_manager_reload () {
   sudo systemctl restart ModemManager
}

uconsole_enable () {
   UCONSOLE_CMD="/usr/local/bin/uconsole-4g-cm4 enable"
   CMD_OUT=$(${UCONSOLE_CMD})
   EXIT_STATUS=$?
   check_exit_status $EXIT_STATUS "${UCONSOLE_CMD}" "${CMD_OUT}"
}



### SCRIPT SETUP ###
# BSD's getopt is simpler than the GNU getopt; we need to detect it
if [ -x /usr/bin/uname ]; then
    OSDETECT=$(/usr/bin/uname -s)
elif [ -x /bin/uname ]; then
    OSDETECT=$(/bin/uname -s)
else
    echo "ERROR: can't run 'uname -s' command to determine system type"
    exit 1
fi

if [ $OSDETECT = "Darwin" ]; then
    ECHO_CMD="echo -e"
elif [ $OSDETECT = "Linux" ]; then
    ECHO_CMD="builtin echo -e"
else
    ECHO_CMD="echo"
fi

# these paths cover a majority of my test machines
for GETOPT_CHECK in "/opt/local/bin/getopt" "/usr/local/bin/getopt" \
    "/usr/local/opt/gnu-getopt/bin/getopt" "/usr/bin/getopt";
do
    if [ -x "${GETOPT_CHECK}" ]; then
        GETOPT_BIN=$GETOPT_CHECK
        break
    fi
done

# did we find an actual binary out of the list above?
if [ -z "${GETOPT_BIN}" ]; then
    echo "ERROR: getopt binary not found; exiting...."
    exit 1
fi

# Use short options if we're using Darwin's getopt
if [ $OSDETECT = "Darwin" -a $GETOPT_BIN = "/usr/bin/getopt" ]; then
    GETOPT_TEMP=$(${GETOPT_BIN} hedn $*)
else
# Use short and long options with GNU's getopt
    GETOPT_TEMP=$(${GETOPT_BIN} -o hedn \
        --long help,enable,disable,dry-run \
        -n "${SCRIPTNAME}" -- "$@")
fi

# if getopts exited with an error code, then exit the script
#if [ $? -ne 0 -o $# -eq 0 ] ; then
if [ $? != 0 ] ; then
    echo "Run '${SCRIPTNAME} --help' to see script options" >&2
    if [ $OSDETECT = "Darwin" -a $GETOPT_BIN = "/usr/bin/getopt" ]; then
        echo "WARNING: 'Darwin' OS and system '/usr/bin/getopt' detected;" >&2
        echo "WARNING: Only short options (-h, -e, etc.) will work" >&2
        echo "WARNING: with system '/usr/bin/getopt' under 'Darwin' OS" >&2
    fi
    exit 1
fi

# Note the quotes around `$GETOPT_TEMP': they are essential!
# read in the $GETOPT_TEMP variable
eval set -- "$GETOPT_TEMP"

# read in command line options and set appropriate environment variables
# if you change the below switches to something else, make sure you change the
# getopts call(s) above
while true ; do
    case "$1" in
        -h|--help) # show the script options
            show_help
            exit 0;;
        -e|--enable)
            show_examples
            exit 0;;
        -d|--disable)
            QUIET=1
            shift;;
        # Explain what will be done, don't actually do
        -n|--dry-run|--explain)
            DRY_RUN=1
            shift;;
        # everything else
        --)
            shift;
            break;;
        # we shouldn't get here; die gracefully
        *)
            echo "ERROR: unknown option '$1'" >&2
            echo "ERROR: use --help to see all script options" >&2
            exit 1
            ;;
    esac
done

### SCRIPT MAIN LOOP ###
# if we're outputting to a pipe, don't colorize, unless ALWAYS_COLORIZE is set
if [ ! -t 1 ]; then
    if [ $ALWAYS_COLORIZE -eq 0 ]; then
        COLORIZE=0
    fi
fi

colorize_clear
if [ $QUIET -eq 0 ]; then
    colorize "$MSG_FLUFF" "=-=-=-=-=-=-=-= "
    colorize "$MSG_INFO" "$SCRIPTNAME"
    colorize "$MSG_FLUFF" " =-=-=-=-=-=-=-="
    $ECHO_CMD $COLORIZE_OUT
    colorize_clear
fi

SOCAT_BIN=$(which socat)
EXIT_STATUS=$?
if [ $EXIT_STATUS -gt 0 ]; then
   colorize $MSG_FAIL "ERROR: can't find 'socat' command"
   exit 1
fi

uconsole_enable
sleep 15
modemmanager_reload
gnss_fw_version
gnss_start

exit ${EXIT_STATUS}

# vi: set filetype=sh shiftwidth=4 tabstop=4
# end of line
