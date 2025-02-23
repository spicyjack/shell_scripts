#!/bin/bash

# run Altirra under WINE
ALTIRRA_HOME="/Users/brian/Working/Altirra/Current"
ALTIRRA_PROFILE="IDEPlus_VBXE_SDX.2023-07-04"
export PATH="/opt/homebrew/bin:/opt/homebrew/sbin:${PATH}"
WINE64_BIN=$(which wine64)
if [ $? -gt 0 ]; then
   echo "ERROR: 'wine64' not installed"
   exit 1
fi

# - Set a default directory for storing profiles
# - Check for a profile file
#   - A profile file contains an ALTIRRA_PROFILE, and a list of disk images to
#     mount in ALTIRRA_DISK_IMGS
# - If no profile file is specified, or the specified profile file does not
#   exist, then list out the profile files in the profile directory
# - Read in the profile file, and parse out it's contents
# - Start Altirra with the parsed contents of the profile file (Altirra
#   profile, disk images to mount, etc.)

if [ ! -e "${ALTIRRA_HOME}/Altirra64.exe" ]; then
   echo "ERROR: can't find Altirra64.exe binary!"
   echo " - Searched directory '${ALTIRRA_HOME}'"
   exit 1
fi

echo "Starting Altirra '${ALTIRRA_PROFILE}'..."
WINEDEBUG=-all $WINE64_BIN \
   ${ALTIRRA_HOME}/Altirra64.exe \
   /portable \
   /d3d9 \
   /profile:${ALTIRRA_PROFILE} \
   2> ${ALTIRRA_HOME}/Altirra64.${ALTIRRA_PROFILE}.wine.log &
