#!/bin/bash

# A script for changing links to correct network files, and resetting 
# the network interface with the new settings

# Written 98/11/08 by Brian Manning

# Inspired by a script from Neil Schneider and a lot of other KPLUGers
# for the boxen Pandora at the Computer Expo

# This script assumes that you have a bunch of different config 
# files for your network adapter, and that you use symbolic links
# to point to the config file you want to use

# This script will search for the file "/etc/network/interfaces.*"
# and return all config files that it finds, so the user can choose which
# one to run. (example: interfaces.test, interfaces.foo, etc.)
# Then the script will redo all of the links, and reset the interface.

# This script uses absolute links to files that come with a default
# Debian Potato distribution.

#begin the main program
clear

# sanity check
if [ $USER != root ]; then 
    echo "Bzzzt! Must be root to run this script..."
    exit
fi # if [$USER]

# well, why are we here?
if [ -z $SCHEME ]; then
    # the $SCHEME was borrowed from PCMCIA, and should work nicely with it
	echo netswitch.sh
    echo This script will configure the network settings for this machine
	echo 
	echo Please choose one of the following configs...
	echo

# display the current config files
	counter=1					#set counter
	for netfiles in /etc/network/interfaces.*		#start file loop
	do
		echo $counter: ${netfiles#*.conf.}	#find all before *.conf.
		counter=$((counter+1))			#update counter
	done

# read the desired network configuration
	echo 
	echo Please type in the number of the congfig to enable
	echo Type the number '0' to exit
	read config_name			#read in the desired config

# now change over to the new config
	#echo
	#echo $config_name
	if [ $config_name != "0" ]; then 	#if the input is non-zero
	counter=1 
	for netfiles in /etc/network/interfaces.*		#start file loop
	  do
		if [ $counter = $config_name ]; then
			echo Bringing down eth0
			/sbin/ifdown eth0			# bring the interface down first

			# let them know what config we are going to
			echo Changing config to ${netfiles#*.conf.}
			echo
			echo Linking resolv.conf to /etc/resolv.conf.${netfiles#*.conf.}

			# resolve files
			if [ -L /etc/resolv.conf ]; then	
				rm /etc/resolv.conf
			fi
			ln -s /etc/network/resolv.conf.${netfiles#*.conf.} /etc/resolv.conf

			# network files
			echo Linking network to /etc/network/interfaces.${netfiles#*.conf.}
			if [ -L /etc/network/interfaces ]; then
				rm /etc/network/interfaces
			fi
			ln -s /etc/network/interfaces.${netfiles#*.conf.} \
                /etc/network/interfaces

		fi # if [ $counter = $config_name ] 
		counter=$((counter+1))          #update counter
	  done # for netfiles 
	fi # if [ $config_name != "0" ]
	echo
	echo Bringing up eth0 with new config
	/sbin/ifup eth0
exit 0

