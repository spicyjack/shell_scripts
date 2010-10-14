#!/bin/bash

# script to view the output of an encrypted file

if [ ! -f $1 ]; then
	echo "Usage:"
	echo "gpg-less <valid readable encrypted file>"
	exit 1
fi

UNAME=`uname -s`

if [ $UNAME == "Darwin" ]; then
    GPG=/opt/local/bin/gpg 
else
    if [ ! -x /usr/bin/gpg ]; then
        echo "ERROR: can't execute /usr/bin/gpg"
        echo "Perhaps you don't have GnuPG installed?"
        exit 1
    fi # if [ ! -x /usr/bin/gpg ];
    # GPG is in /usr/bin/gpg
    GPG=/usr/bin/gpg
fi # if [ $UNAME == "Darwin" ];
    
$GPG -d $1 2>/dev/null | /usr/bin/less

/bin/stty sane

clear

exit 0
