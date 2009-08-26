#!/bin/sh

# script to build rcfiles tarball

CONSOLE_FONT_FILE="/home/ftp/linux/apps/fonts/lode-lat1u-16.psf"
SUNSPOT_FILE="/home/ftp/win/crap/pix/sunspots/sunspot_swedish-640x480.xpm.gz"
DEMO_DIR="/home/ftp/linux/demo"
CVS_TOP="/home/brian/cvs"

# external programs
CP=$(which cp)
MKDIR=$(which mkdir)
MKTEMP=$(which mktemp)
TAR=$(which tar)

# get a temporary directory
TEMPDIR=$($MKTEMP -d -p $DEMO_DIR)

# now build the archive
cd $TEMPDIR
$CP $CVS_TOP/brians_crap/vimrc .vimrc
$CP $CVS_TOP/brians_crap/dir_colors .dir_colors
$CP $CVS_TOP/brians_crap/bashrc .bashrc
# make an ssh directory for the SSH key as well
$MKDIR .ssh
$CP ~/.ssh/authorized_keys .ssh
# sunspot
$CP $SUNSPOT_FILE .
# console font
$CP $CONSOLE_FONT_FILE .

# create the tarball
$TAR -cvf ../rcfiles.tar .[a-zA-Z0-9]* *

# then nuke the temp directory
/bin/rm -rf $TEMPDIR

# exit with 0 status
exit 0
