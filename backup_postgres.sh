#!/bin/bash

# script to back up the mp3db

# (c)2002 Brian Manning
# Released under the terms of the GNU GPL v2

# NOTE: this script is specific to my system.  Adjust accordingly to your
# system, then add the shell script to a crontab for automatic db dumps

# requires the pg_dumpall command line client, date command, bzip2 libs,
# nice command.  Most modern Linux distros should have all of these
# already, or only a package or two away

# get the current date
DATE=`date +%Y%b%d`
NICE="/usr/bin/nice -n 19"
PG_DUMPALL="/usr/lib/postgresql/bin/pg_dumpall"

# remove the old symlink for latest dump
/bin/rm /var/lib/postgres/backups/latest_dump.out.bz2

# run the psql dump
$NICE $PG_DUMPALL > /var/lib/postgres/backups/pg_dump_$DATE.out

# bzip the dump
$NICE /usr/bin/bzip2 /var/lib/postgres/backups/pg_dump_$DATE.out

# make a symlink to the latest dump
/bin/ln -s /var/lib/postgres/backups/pg_dump_$DATE.out.bz2 \
	/var/lib/postgres/backups/latest_dump.out.bz2


