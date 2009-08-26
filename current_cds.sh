#!/bin/sh

/usr/bin/find /home/ftp/other/albums/ -name "*.mp3" \
    | awk -F'/' '{print $6 " - " $7;}' \
    | sed 's/^The //' | uniq | sort | less \
    | a2ps --stdin="Brian's CD Collection" -1 -o ~/current_cds.ps
    #| a2ps --stdin="Brian's CD Collection" -2 --columns 2 -o ~/current_cds.ps
