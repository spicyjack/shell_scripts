#! /bin/sh

# $Id: vpnc.sh,v 1.3 2008-10-04 18:54:33 brian Exp $
# Copyright (c)2007 Brian Manning <elspicyjack at gmail dot com>

# color control strings
START="["
END="m"

# some common message strings
SUCCESS=" success."
FAILED=" failed."

# text attributes
NONE=0; BOLD=1; NORM=2; BLINK=5; INVERSE=7; CONCEALED=8

# background colors
B_BLK=40; B_RED=41; B_GRN=42; B_YLW=43
B_BLU=44; B_MAG=45; B_CYN=46; B_WHT=47

# foreground colors
F_BLK=30; F_RED=31; F_GRN=32; F_YLW=33
F_BLU=34; F_MAG=35; F_CYN=36; F_WHT=37

# some shortcuts
S_SUCCESS="${BOLD};${F_GRN};${B_BLK}"
S_FAILURE="${BOLD};${F_RED};${B_BLK}"
S_INFO="${F_BLK};${B_CYN}"
S_TIP="${BOLD};${F_BLU};${B_BLK}"
T_SUCCESS="${BOLD};${F_WHT};${B_GRN}"
T_FAILURE="${BLINK};${F_YLW};${B_RED}"
T_INFO="${INVERSE};${F_WHT};${B_BLU}"
T_TIP="${CONCEALED};${F_BLK};${B_WHT}"

colorize () {
# colorize some text; $1 == color tag(s), $2 == text to colorize
    echo -n "${START}${1}${END}${2}${START};${NONE}${END}"
} # colorize()

colorize_nl () {
# same as colorize(), but with a newline added at the end
    colorize "${1}" "${2}"
    $BB echo
} # colorize_nl() 

cmd_status () {
# check the status of the last run command; run a shell if it's anything but 0
    STATUS=$1
    if [ $STATUS -ne 0 ]; then
        colorize_nl $S_FAILURE "$FAILED"
        colorize $S_FAILURE "Previous command failed with status code: "
        colorize_nl $S_INFO ">${STATUS}<"
    else
        colorize_nl $S_SUCCESS "$SUCCESS"
    fi
}

ACTION=$1
BINARY="/opt/local/sbin/vpnc"
[ -x "$BINARY" ] || exit 1
BASENAME=$(/usr/bin/basename $BINARY)
DESC="vpnc IPSEC VPN Tunnel"
VPNC_PROFILE="qc"
VPNC_PID="/var/run/vpnc.pid"
BINARY_OPTS="--debug 1 --natt-mode cisco-udp --pid-file ${VPNC_PID}"

case "$ACTION" in
  vars)
    # echo out what commandline variables are parsed by this script
    echo "${BASENAME}:"
    exit 0
  ;;
  start)
	colorize_nl $S_INFO "Starting $DESC..."
	colorize_nl $S_INFO "Enter your password at the SUDO prompt (if any);"
	sudo $BINARY $BINARY_OPTS $VPNC_PROFILE
    cmd_status $?
	;;
  stop)
	PATH=/bin:/sbin:/usr/bin:/usr/sbin
	colorize_nl $T_INFO "Stopping $DESC;"
	colorize_nl $S_INFO "Enter your password at the SUDO prompt (if any);"
    sudo kill -TERM $(cat ${VPNC_PID}) 
    cmd_status $?
	;;
  restart|force-reload)
 	$0 stop
 	$0 start
	;;
  *)
	echo "Usage: $BASENAME {start|stop|restart|force-reload}" >&2
	exit 3
	;;
esac

exit 0
