#!/bin/bash

PROGNAME=$(/usr/bin/basename $0)

check_racoon_process () {
    #echo "Checking for racoon processes"
    RACOON_PROCESSES=$(ps auxw | grep racoon \
        | egrep -v "grep|${PROGNAME}" | wc -l)
    #echo "Found ${RACOON_PROCESSES}"
}

echo "This script requires SUDO access."
echo "Enter your SUDO password if prompted, or hit Ctrl-C to exit..."
sudo -v

check_racoon_process
if [ $RACOON_PROCESSES -gt 0 ]; then
    echo "Running 'sudo launchctl stop com.apple.racoon'"
    sudo launchctl stop com.apple.racoon
fi

check_racoon_process
if [ $RACOON_PROCESSES -eq 0 ]; then
    echo "/usr/sbin/racoon process stopped"
else
    echo "ERROR: could not stop /usr/sbin/racoon process"
    exit 1
fi

echo "Running 'sudo launchctl start com.apple.racoon'"
sudo launchctl start com.apple.racoon

check_racoon_process
if [ $RACOON_PROCESSES -gt 0 ]; then
    echo "/usr/sbin/racoon process restarted succcessfully"
    exit 0
else
    echo "ERROR: /usr/sbin/racoon process not running after restart"
    exit 1
fi
