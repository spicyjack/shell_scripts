#!/bin/sh

# script to start vpnc
echo "Starting 'vpnc'; Enter your SUDO password if prompted"
#sudo dtruss /opt/local/sbin/vpnc --debug 3 --natt-mode cisco-udp qc
sudo /opt/local/sbin/vpnc --debug 2 --natt-mode cisco-udp qc
