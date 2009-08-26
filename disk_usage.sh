#!/bin/sh

# disk usage monitoring script

# get the current percentage of / 
PCT=`df -h /  |grep "/$" | awk '{print $4}' | sed 's/%//'`
THRESHOLD=90

# if the disk usage is over the threshold
if [ $PCT -ge $THRESHOLD ]; then
    # and a disk usage alarm file does not already exist
    if [ ! -e /tmp/diskalarm.txt ]; then
        # touch an alarm file so only one alarm is sent
        touch /tmp/diskalarm.txt
        # then send the actual alarm
        echo "Disk usage on streamserver is greater than $THRESHOLD percent" \
        | mail -s "Disk Usage Report" matt@ocp.com
    fi # if [ ! -e /tmp/diskalarm.txt ]
else
    # disk usage is under the threshold, remove an alarm file if it exists
    if [ -e /tmp/diskalarm.txt ]; then
        rm /tmp/diskalarm.txt
    fi
fi # if [ $PCT -ge $THRESHOLD ];

