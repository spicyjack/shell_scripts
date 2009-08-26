#!/bin/sh

# script to create a bunch of split files which are the bzipped QEMU hard drive
# image

OUTPUT_FILE=$1

if [ -z $OUTPUT_FILE ]; then
    echo "Please pass in a filename to be used as the archive name"
    exit 1
fi

# make a directory for the output files
/bin/mkdir $OUTPUT_FILE
if [ $? -gt 0 ]; then
    echo "mkdir ${OUTPUT_FILE} failed with error code ${?}"
    exit 1
fi

# run the compress/split
/usr/bin/bzip2 -9 -c disk1.qcow2 \
    | split --bytes 100m --verbose - $OUTPUT_FILE.bz2.part 

# move the files into the output directory
/bin/mv $OUTPUT_FILE.bz2.part* $OUTPUT_FILE/

/usr/bin/md5sum $OUTPUT_FILE/$OUTPUT_FILE.bz2.part* \
    | /usr/bin/tee $OUTPUT_FILE/md5sums.txt
