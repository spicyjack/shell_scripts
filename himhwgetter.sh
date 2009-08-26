#!/bin/sh

# script to download harmony in my head show zipfiles

YEAR="2007"
MONTH="December"
FILE="dec04part"
URL="http://www.rollins-archive.com/${YEAR}/${MONTH}/"
for PART in 1 2 3 4; do 
    echo "wgetting part ${PART}"
    wget "${URL}${FILE}${PART}.zip"
    echo "unzipping part ${PART}"
    if [ -f "${FILE}${PART}.zip" ]; then
        unzip "${FILE}${PART}.zip"
        if [ $? -eq 0 ]; then
            # the unzip process exited with 0 status
            rm "${FILE}${PART}.zip"
        else
            echo "unzip process exited with status ${?}"
            echo "*not* removing downloaded files"
        fi
    else
        echo "File ${FILE}${PART}.zip not found/downloaded"
        echo "Check for wget errors to see what happened"
    fi
done
