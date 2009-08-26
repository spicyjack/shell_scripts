#!/bin/bash

# script to start a copy of acl.pl on $1

/usr/bin/tail -F /var/log/$1 \
    | /bin/grep --line-buffered -v imapd \
    | /usr/local/bin/acl.pl
# changed the acl.pl script to suppress imapd logins

#/usr/bin/tail -F /var/log/$1 \
#    | grep -vE "Unhandled event|Ignoring x86 page event" \
#    | /usr/local/bin/acl.pl
