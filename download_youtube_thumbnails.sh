#!/bin/bash

# script to download "all" of the thumbnails that are available for a YouTube
# video
VIDEO_FILENAMES="0 1 2 3 default hqdefault mqdefault sddefault maxresdefault"
VIDEO_BASEURL="https://img.youtube.com/vi"

if [ -z $1 ]; then
   echo "Usage: $0 <YouTube video identifier>"
   exit 1
else
   echo "Downloading YouTube videos for identifier: $1"
   VIDEO_ID=$1
fi

for VF in $VIDEO_FILENAMES;
do
   echo "Downloading $VF"
   wget ${VIDEO_BASEURL}/${VIDEO_ID}/${VF}.jpg
done
