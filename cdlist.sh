#!/bin/sh
DATE=$(/bin/date)
OUTFILE="/home/drupal/misc/antlinux/cdlist.txt"

echo "Brian's CD list, current to ${DATE}" > $OUTFILE
echo "======================" >> $OUTFILE
/usr/bin/find /home/ftp/other/albums -type d -maxdepth 2 \
    | /bin/sed 's/\/home\/ftp\/other\/albums\//- /' \
    | /bin/sed 's/^\/home\/ftp\/other\/albums$//' \
    | /bin/sed '/^$/d' |  /bin/grep "/" | /usr/bin/sort \
    >> $OUTFILE
