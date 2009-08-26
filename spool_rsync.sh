#!/bin/sh

# script to tar my mailspool to a remote machine

DATE=`TZ=GMT /bin/date`

/bin/echo "============================================================="
/bin/echo "Beginning mail spool sync at ${DATE}"
/bin/echo "============================================================="

/usr/bin/rsync -azv -e "/usr/bin/ssh -i /home/bmanning/.ssh/id_spoolbackup" \
/home/bmanning/Mail bmanning@platinum.qualcomm.com:
/usr/bin/rsync -azv -e "/usr/bin/ssh -i /home/bmanning/.ssh/id_spoolbackup" \
--exclude=mail_sync.log \
/home/bmanning/.procmail bmanning@platinum.qualcomm.com:

