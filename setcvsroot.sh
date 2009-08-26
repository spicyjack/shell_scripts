#!/bin/sh

# sets CVSROOT environment variable, so that you can connect to a 
# server, and check out filez

# first, clear .cvslogin

echo "Clearing current login"
cvs logout

case "$1" in 
	1|local)
	export CVSROOT=/home/cvs
	;;
	2|localhost)
	export CVSROOT=:pserver:brian@localhost:/home/cvs
	echo "Logging into remote server via ssh connection..."
	cvs login
	;;
	3|livid)
	export CVSROOT=:pserver:anonymous@cvs.linuxvideo.org:/cvs/livid
	echo "Logging into cvs.linuxvideo.org, password is <CR>"
	cvs login
	echo "checkout command is cvs -z3 co -P ac3dec oms mpeg2dec mgadvd"
	;;
	4|orpg)
	export CVSROOT=:pserver:cvsread@www.rpgarchive.com:/usr/local/rpgcvs
	echo "Logging into www.rpgarchive.com, password is openrpg"
	cvs login
	echo "checkout command is cvs -z3 co -P openrpg"
	echo "Run checkout now? [Y/n] "
	read $answer
	if [ "$answer" != "n" -o "$answer" != "N" ]; then
		/usr/bin/cvs -z3 co -P openrpg
	fi
	;;
	5|orpgsf)
	export CVS_RSH=/usr/local/bin/ssh1
#	export CVSROOT=:pserver:cvsread@www.rpgarchive.com:/usr/local/rpgcvs
	echo "Logging into openrpg@sourceforge"
	cvs login
	echo "checkout command is cvs -z3 co -P openrpg"
	echo "Run checkout now? [Y/n] "
	read $answer
	if [ "$answer" != "n" -o "$answer" != "N" ]; then
		/usr/bin/cvs -z3 co -P openrpg
	fi
	;;
	*)
	echo "Please select the CVSROOT tree that you want to use:"
	echo
	echo "[1 | local] Local (/home/cvs)"
	echo "[2 | localhost] Remote server via SSH"
	echo "[3 | livid] LiViD - Linux DVD project"
	echo "[4 | openrpg] OpenRPG - Open RPG project"
	exit 1
	;;
esac ## case "$1"
