#!/bin/bash

# run Neo6502 under WINE
NEO6502_VERSION="v1.0.0"
NEO6502_HOME="${HOME}/neo6502.${NEO6502_VERSION}"

export PATH="/opt/homebrew/bin:/opt/homebrew/sbin:${PATH}"
WINE_BIN=$(which wine)
if [ $? -gt 0 ]; then
   echo "ERROR: 'wine' (32-bit) not installed"
   exit 1
fi

if [ ! -e "${NEO6502_HOME}/neo.exe" ]; then
   echo "ERROR: can't find 'neo.exe' binary!"
   echo " - Searched directory '${NEO6502_HOME}'"
   exit 1
fi

START_PWD=${PWD}
cd ${NEO6502_HOME}
$WINE_BIN \
   ${NEO6502_HOME}/neo.exe \
   2> ${NEO6502_HOME}/neo.exe.wine.log &

cd ${START_PWD}
