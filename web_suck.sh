#!/bin/sh

# script to web suck spammers

# variables
SPAMMER="2148225744/nailgirls/?sexporn"
LOG_FILE="web_suck.log"
OUT_FILE="~/$SPAMMER.out"
DOT_STYLE="micro"
WAIT_TIME="3"
NUM_OF_TRIES="0"
USER_AGENT="Spam_Sucker/version-FUCK_YOU"
#EXTRA_OPTIONS="-b -S --spider --cache off" # -S is show server response
EXTRA_OPTIONS="--spider --cache off" # -b is background itself

while [ -e web_suck.run ];
do
	wget $EXTRA_OPTIONS --tries $NUM_OF_TRIES \
	--user-agent $USER_AGENT http://$SPAMMER
	sleep 1s
done
