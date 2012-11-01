#!/bin/bash
#=============================================================
# File     : dburn-wavs (cdrdao)
# Author   : Dave Maley
# Version  : 1.10
# Created  : 1/23/04
# Modified : 9/27/04
# Abstract : Used for burning audio CD's
# Notes    : Requires cdrdao
#          : This script is custom for Homer's device and driver
#=============================================================

usage () {
    echo -e "\nusage: dburn-wavs [-p path]"
    echo -e "\n   example: dburn-wavs -p /tunes/ymsb2003-11-19d1"
    echo -e "\n\tNote: path can be relative or full"
    exit 1
}

# Check # of args
if [ $# -gt 2 ]
then
    usage
elif [ $# -gt 0 ] && [ $1 != "-p" ]
then
    usage
fi

which cdrdao > /dev/null 2>&1
CDRDAO_WHICH_STATUS=$?
if [ $CDRDAO_WHICH_STATUS -gt 0 ]; then
    echo 'ERROR: cdrdao not found in $PATH'
    exit 1
fi

# Initialize Varialbles
path=NULL
tmpfile=/tmp/tmp.toc
#DEVICE=ATAPI:16,0,0
#DEVICE=ATA:1,0,0
DEVICE="IODVDServices/0"
#DEVICE="0,1,0"
DRIVER="generic-mmc-raw"

# Parse command line
while [ $# -gt 0 ]; do
    case $1 in
	-p)
	    shift
	    path=$1
	    ;;
	-*help)
	    usage
	    ;;
	-*)
	    usage
	    ;;
	*)
	    ;;
    esac
    shift
done

# if $path isn't set default it to PWD
if [ "${path}" = "NULL" ]
then
    path=`/bin/pwd`
fi

# check that $path exists
if [ ! -d "${path}" ]
then
    echo -e "\nERROR: $path does not exist!\n"
    exit 1
fi

# convert $path to absolute path
cd "${path}"
path=`/bin/pwd`

# check for wav files in $path
wavfiles=$(ls *.wav 2> /dev/null | wc -l)
if [ $wavfiles -eq 0 ]
then
    echo "\nERROR: No wav files found in $path\n"
    exit 1
fi

# create TOC
echo "CD_DA" > $tmpfile
for i in `ls *.wav`; do
   echo "TRACK AUDIO" >> $tmpfile
   echo "FILE \"$i\" 0" >> $tmpfile
done

# burn CD and eject
/bin/echo -e "\nBurning waves in $path"
/bin/echo -e "\nPrompting for SUDO password:"
sudo time cdrdao write --device $DEVICE --driver $DRIVER --eject -n $tmpfile

# clean-up
rm -f $tmpfile

# Bye
echo -e "\nThanks for using dburn-wavs (cdrdao)!\n\n"
exit 0

# Change Log
# * Mon Sep 27th 2004 dmaley at nc.rr.com v1.10
# - re-designed usage output
# - command parsing now done in case statement
# - force $path to be absolute path
#
# * Thu Jun 17th 2004 dmaley at nc.rr.com v1.04
# - modified $DEVICE for ATAPI (FC2)
#
# * Tue Feb 4th 2004 dmaley at nc.rr.com v1.03
# - added time command
#
# * Mon Jan 26th 2004 dmaley at nc.rr.com v1.02
# - "--device" and "--driver" are now variables
#
# * Fri Jan 23rd 2004 dmaley at nc.rr.com v1.01
# - created initial version/re-write for cdrdao
#
