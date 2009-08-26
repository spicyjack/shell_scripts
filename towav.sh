#!/bin/sh

# script to convert SHN/FLAC files to WAV files for burning to CD
# $Id: towav.sh,v 1.2 2006-08-28 18:30:11 brian Exp $

# check to see if an out directory was specified
if [ -z $1 ]; then
    echo "Usage: $0 /path/to/save/output/files"
    exit 1
fi

if [ ! -w $1 ]; then
    echo "ERROR: output directory '$1' not writeable; exiting..."
    exit 1
fi
    
for FILETEST in *;
do
    SUFFIX=$(echo ${FILETEST} | sed "s/.*\.\(.*\)$/\1/")
    # set the filetype based on the first valid matching file; this prevents
    # files that can't be decoded from becoming the filetype
    if [ $SUFFIX == "flac" -o $SUFFIX == "shn" ]; then
        break
    fi
done

echo -e "Files in ${PWD}\nare in '${SUFFIX}' format"
 
for FILE in *.$SUFFIX; 
do 
    NEWFILE=$(ls ${FILE} | sed "s/${SUFFIX}$/wav/")
    case $SUFFIX in
        flac) /usr/bin/flac -d -c $FILE > $1/$NEWFILE;;
        shn) /usr/bin/shnconv -o wav -d $1 $FILE;;
        #flac) echo "would have converted ${FILE} via flac";;
        #shn) echo "would have converted ${FILE} via shntool";;
    esac
done

