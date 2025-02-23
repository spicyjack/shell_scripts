#!/bin/bash

# run Altirra under WINE
ALTIRRA_HOME="/Users/brian/Working/Altirra/Current"
#ALTIRRA_HOME="/Users/brian/Working/Altirra/Altirra-4.30-test8"
export PATH="/opt/homebrew/bin:/opt/homebrew/sbin:${PATH}"
WINE64_BIN=$(which wine64)
if [ $? -gt 0 ]; then
   echo "ERROR: 'wine64' not installed"
   exit 1
fi

if [ ! -e "${ALTIRRA_HOME}/Altirra64.exe" ]; then
   echo "ERROR: can't find Altirra64.exe binary!"
   echo " - Searched directory '${ALTIRRA_HOME}'"
   exit 1
fi

# Command line for using the ATASM-Altirra Bridge
# https://forums.atariage.com/topic/320979-modern-tool-chain-for-8bit-development/#findComment-5056979
WINEDEBUG=-all $WINE64_BIN \
   ${ALTIRRA_HOME}/Altirra64.exe \
   /portable \
   /d3d9 \
   /profile:IDEPlus_SDX_Games.2025-02-15 \
   /baseline \
   $@ \
   2> ${ALTIRRA_HOME}/Altirra64-IDEPlus_SDX_Games.2025-02-15.wine.log &
#   /defprofile:xl \

