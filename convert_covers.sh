#!/bin/sh

# script to copy out artwork from iTunes files

# based on ideas shown in:
# http://marv.kordix.com/convertITC
# http://marv.kordix.com/archives/000917.html

OLDPWD=$PWD
ART_DIR=$HOME/Music/iTunes/Album\ Artwork
echo "Changing directory to the iTunes Album Artwork directory"
cd $HOME/Music/iTunes/Album\ Artwork

DONE_FILES=$HOME/Music/iTunes/scraped_artwork_files.txt
if [ ! -e $DONE_FILES ]; then touch $DONE_FILES; fi

for ITC in $(find . -name "*.itc"); 
do 
    SHORTNAME=$(basename $ITC)
    #echo "- Checking $SHORTNAME in $DONE_FILES"
    ALREADY_DONE=$(grep -c $SHORTNAME $DONE_FILES)
    #echo "Check for already done file: '$ALREADY_DONE'"
    if [ $ALREADY_DONE -eq 0 ]; then
    	isJPEG=$(grep -E "EExIf|JFIF" $ITC)
	    isPNG=$(grep PNG $ITC)

    	if [ -n "$isJPEG" ]; then
    	    EXT=jpg
	    elif [ -n "$isPNG" ]; then
    		EXT=png
        fi
	
    	if [ -n "$EXT" ]; then
            echo "Found new file; creating $SHORTNAME.$EXT"
    	    tail -c +493 $ITC > $SHORTNAME.$EXT
            echo $SHORTNAME >> $DONE_FILES
	    else
        	echo "Format not recognized for file:"
            echo "$ITC"
        	echo "EXT- $EXT"
        	echo "PNG- $isPNG"
        	echo "JPEG- $isJPEG"
	    fi
    else
        echo "File $SHORTNAME has already been converted"
    fi # if [ -n $ALREADY_DONE ]
done # for ITC in $(find . -name "*.itc")

echo "Returning to $OLDPWD"
cd "$OLDPWD"
