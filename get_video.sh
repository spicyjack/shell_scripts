#!/bin/sh

# script to download a video from CNN

# sample URL
if [ $# -ge 1 ]; then
    VIDEO=$1
else
    VIDEO="http://dynamic.cnn.com/apps/tp/video/us/2005/09/13/cooper.bridge.controversy.cnn/video.ws.asx?NGUserID=aa54a10-11565-1122753890-2&adDEmas=false"
fi

URL=`echo $VIDEO | awk -F'?' '{print $1}'`
echo "URL is ${URL}"

URLFILE=`echo $URL | awk -F'/' '{last=NF; --last; print $last}'`
echo "URLFILE is ${URLFILE}"

#wget -O - $URL | grep href | sed 's/^<.*="//' | sed 's/"\/>//'

mplayer -dumpstream -dumpfile ${URLFILE}.wmv \
    `wget -O - $URL | grep -i ref | sed 's/^<.*="//' | sed 's/"\/>//'`

