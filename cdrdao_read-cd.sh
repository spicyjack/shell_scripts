#!/bin/bash

# get the name of the datafile from the toc file
BIN_NAME=`echo $1 | /bin/sed 's/\.toc$/.bin/i'`

# now exit if the filename passed in is bogus
# if there's no $1
if [ ! $1 ]; then
	echo "$0: Usage:"
	echo "$0: $0 somefilename"
	echo "The '.toc' extension will be added by the script automagically"
fi

echo "Creating an image and TOC file in /usr/local/src called '$BIN_NAME'"

/usr/local/bin/cdrdao read-cd \
--device 0,0,0 --driver generic-mmc \
--datafile /usr/local/src/$BIN_NAME.bin /usr/local/src/$1.toc
