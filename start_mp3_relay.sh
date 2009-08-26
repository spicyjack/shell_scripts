#!/bin/sh

# download the stream with wget,
# then pipe the output to streamcast

wget -q -O - http://gw:8000 | streamcast.pl -i
