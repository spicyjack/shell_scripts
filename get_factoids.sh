#!/bin/sh

SOURCE_URI="http://sbih.org/Prospero"
OUTPUT_DIR="/var/www/purl/html/Prospero"
#WGET_OPTS="-N"
for FILE in Prospero-are.dir Prospero-are.pag Prospero-is.dir Prospero-is.pag;
do
    # -q quiet
    wget -q -O $OUTPUT_DIR/$FILE $SOURCE_URI/$FILE
done
