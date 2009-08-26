#!/usr/local/bin/bash

# base directory this all runs from
BASE="/var/clients"

# script to run smbtar on clients

# for each client in client_list.txt
for CLIENT in `cat ${BASE}/client_list.txt`; do
    # parse out the hostname (for file/directory names)
    HOST_NAME=`echo $CLIENT | awk -F":" '{print $1}'`
    # parse out the IP address
    HOST_IP=`echo $CLIENT | awk -F":" '{print $2}'`
    # put the host being worked on into the logs
    echo "HOST_NAME is ${HOST_NAME}, HOST_IP is ${HOST_IP} " >> $BASE/backup.log
    # check to see if a previous backup failed to clean up
    if [ -d $BASE/$HOST_NAME.* ]; then 
        echo "WARNING: previous backup of $HOST_NAME failed!!!" >> \
            $BASE/backup.log
        exit 1
    else 
        # create a directory with the current PID as part of the name
        /bin/mkdir $BASE/$HOST_NAME.$$
        # then cd into that directory for the next step
        cd $BASE/$HOST_NAME.$$
        # run the actual smbtar
        #/usr/local/bin/smbclient //${HOST_NAME}/respaldo -I $HOST_IP \
        #-U "Administrator%\!gV178tK6" -T c ${HOST_NAME}.tar 2>&1 >> backup.log
        /usr/local/bin/smbclient //${HOST_NAME}/respaldo -I $HOST_IP \
        -U "Administrator%\!gV178tK6" -T c 2>> $BASE/backup.log \
        | tar xf - 2>> $BASE/backup.log
        # if the previous program exited with a good status
        if [ $? -eq 0 ]; then
            # remove the old backup
            /bin/rm -rf $BASE/$HOST_NAME
            # move the new backup to the original name
            /bin/mv $BASE/$HOST_NAME.$$ $BASE/$HOST_NAME
        else
            echo "WARNING: tar exited with status $?"
            exit 1
        fi # if [ $? -eq 0 ]; then
    fi # if [ -d $BASE/$HOST_NAME ]; then
done # for CLIENT in `cat ${BASE}/client_list.txt`; do
