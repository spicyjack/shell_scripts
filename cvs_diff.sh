#!/bin/sh

# runs cvs diff on an input file

# constants
#$CVSROOT="CVSROOT=:pserver:cvsread@www.rpgarchive.com:/usr/local/rpgcvs"

if [ -z $1 ]; then
	echo "Usage: cvs_diff.sh filename, where filename is the name of the "
	echo "       file that you want to compare off of the remote repository"
	exit 1
fi

#/usr/bin/env $CVSROOT 

cvs diff -u -t $1 > $1.diff

echo "diff from remote server complete"

exit 0

