#!/bin/bash

for HEIC in *.heic;
#CONVERT_OPTS="-strip -resize 1500"
do
   JPEG=$(echo $HEIC | sed 's/.heic/.jpg/')
   echo "Converting ${HEIC} to ${JPEG}"
   convert $CONVERT_OPTS $HEIC $JPEG
done
