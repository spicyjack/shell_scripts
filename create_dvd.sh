#!/bin/csh
#
# Burn a DVD from a set of MPEG files
#   Note: Uses disk bookmark resetting to fool some dumb players
#
# Input:
# 1-255: MPEG files to be chapters of DVD
#

dvddirgen -o tmp_dvd -r
dvdauthor -o tmp_dvd $argv
dvdauthor -o tmp_dvd -T

dvd+rw-format -force /dev/cdrom
dvd+rw-booktype -dvd-rom-spec -unit+rw /dev/cdrom

growisofs -speed=1 -dvd-compat -overburn -Z /dev/cdrom -R -udf -dvd-video tmp_dvd

rm -rf tmp_dvd
