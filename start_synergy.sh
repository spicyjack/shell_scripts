#!/bin/sh

# start synergy server
/usr/bin/synergys --config /usr2/bmanning/.synergy.conf

# start the client as well
/usr/bin/synergyc localhost
