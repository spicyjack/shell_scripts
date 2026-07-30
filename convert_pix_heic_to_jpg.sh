#!/bin/bash

CONVERT_OPTS="-strip -resize 1500"
for HEIC in *.heic;
do
   JPEG=$(echo $HEIC | sed 's/.heic/.jpg/')
   echo "Converting ${HEIC} to ${JPEG}"
   convert $CONVERT_OPTS $HEIC $JPEG
done
