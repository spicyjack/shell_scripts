#!/bin/sh

# script to dump the latest webcam image
# $Id: antfarm.sh,v 1.2 2006-05-31 04:20:24 brian Exp $

# where does the image get written to?
INFILE="/home/antlinux/html/pix/antfarm-raw.jpg"
OUTFILE="/home/antlinux/html/pix/antfarm.jpg"
PIDFILE="/home/antlinux/html/pix/antfarm.sh.pid"
# get a nice date for use at the bottom of the image
DATE=$(date "+%a %d%b%Y %T %Z")

# check for a PID file; exit if one exists, create one if one doesn't exist
if [ -f $PIDFILE ]; 
then
	echo "antfarm.sh already running as $(cat ${PIDFILE}) at ${DATE}"
	exit 1
else
	echo $$ > $PIDFILE
fi

# grab the date/time of the capture for superimposing on the image with 
DATE="'Antlinux Antfarm - http://www.antlinux.com/pix/antfarm.jpg - San Diego, CA USA - $DATE'"

# now run imagemagick on it
# 'rectangle <x,y of upper left corner>,<x,y of lower right corner>'
/usr/bin/convert \
 -fill "#0008" -draw 'rectangle 0,460,640,480' \
 -fill white -draw "text 10,475 ${DATE}" \
 $INFILE $OUTFILE

# remove the PID if we've reached this far without errors
/bin/rm $PIDFILE
