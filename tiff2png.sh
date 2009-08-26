#!/bin/sh

# converts a group of TIFF files (from the mac scanner) to PNG

# FIXME build an attributions file
for FILE in $(ls *.tif); do
    # FIXME do some sed majik to the filename here, trade .tif to .alpha and
    # .png
    /usr/bin/tifftopnm --alphaout=DnD-Map_Key.alpha \
        $FILENAME.tif > $FILENAME.ppm

    /usr/bin/pnmtopng -alpha DnD-Map_Key.alpha -ztxt attributions.txt \
        -compression 9 -interlace $FILENAME.ppm > $FILENAME.png

    # delete the ppm file?
done
