#!/bin/bash

# afio script to back up my MP3's

# -o 		archive
# -b 10k 	10k blocksize
# -v 		verbose
# -G 1		GZIP at level 1
# -M 32M 	give GZIP 32 megs for a buffer for compressing files
# -T 3k		only compress files above 3k in size
# -Z 		use gzip to compress files
# -L ~/mp3_backup.log log file path
find /home/ftp/other -name "*.mp3" -print | \
/bin/afio -o -b 10k -v -M 32m -T 6k -L ~/mp3_backup.log /dev/nst0

