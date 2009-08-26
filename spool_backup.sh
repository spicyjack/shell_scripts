#!/bin/sh

# script to tar my mailspool to a remote machine

DATE=`TZ=GMT /bin/date`

/bin/echo "Beginning mail spool remote backup at ${DATE}"
/bin/echo "============================================================="

/bin/tar jcv ~/Mail ~/.procmail | \
    /usr/bin/ssh -i ~/.ssh/id_spoolbackup -C bmanning@platinum.qualcomm.com \
    'cat > ~/mail_backup.tar.bz2'
