#!/bin/bash

# changes the domain listed in project/CVS/Root
# use "find . -name Root | xargs grep sunset > baddomains.txt" to generate a
# list of domains for this script to work on

BADFILES=badfiles.txt			# a temp file for holding the results of find
FILENAME=Root 					# filename to search for
BADPATTERN="sunset-cliffs.org"	# the pattern we're looking for
GOODPATTERN="antlinux.com"		# the pattern we will be replacing
FIND=/usr/bin/find
GREP=/bin/grep
XARGS=/usr/bin/xargs
SED=/bin/sed
CAT=/bin/cat

# run the find to find the bad pattern
# we need to have a list of filenames so we can re-write those files
# just using find/xargs, we loose the filename to write back to
# find -name finds a specific filename
# grep -l prints only the filename that a match ocurred in, not the matched
# string itself
$FIND $PWD -name $FILENAME | $XARGS $GREP -l $BADPATTERN > $BADFILES

# now read back in the badfiles
for x in `cat $BADFILES`; do
	echo "Now running sed on $x"
	$CAT $x | $SED "s/sunset\-cliffs\.org/antlinux.com/" > $x
done

# remove $BADFILES
/bin/rm $BADFILES
