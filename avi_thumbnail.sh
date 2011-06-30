#!/bin/sh

# script to generate thumbnails for avi movies

for AVI in *.avi;
do
    PNM=$(echo ${AVI} | sed s/avi$/pnm/)
    JPG=$(echo ${AVI} | sed s/avi$/jpg/)
    echo "==== Creating PNM thumbnail from $AVI ===="
    lav2yuv -f 1 $AVI | y4mtoppm -L > $PNM
    echo "==== Creating ${JPG} from $PNM ===="
    convert $PNM $JPG
    rm $PNM
done
