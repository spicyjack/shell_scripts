#!/bin/bash

# run Altirra under WINE 64-bit
ALTIRRA_HOME="/path/to/altirra/dir"
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

$WINE64_BIN \
   ${ALTIRRA_HOME}/Altirra64.exe \
   /portable \
   /d3d9 \
   2> ${ALTIRRA_HOME}/Altirra64.wine.log &
