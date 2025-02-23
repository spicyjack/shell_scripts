#!/bin/bash

# run Altirra under WINE
ALTIRRA_HOME="/Users/brian/Working/Altirra/Current"
ALTIRRA_PROFILE="IDEPlus_VBXE_SDX.2023-07-04"
PROFILE_DIR="${HOME}/Working/Altirra/Profiles"
export PATH="/opt/homebrew/bin:/opt/homebrew/sbin:${PATH}"

# check for WINE64
WINE64_BIN=$(which wine64)
if [ $? -gt 0 ]; then
   echo "ERROR: 'wine64' not installed"
   exit 1
fi

# check for Altirra
if [ ! -e "${ALTIRRA_HOME}/Altirra64.exe" ]; then
   echo "ERROR: can't find Altirra64.exe binary!"
   echo " - Searched directory '${ALTIRRA_HOME}'"
   exit 1
fi

if [ ! -d $PROFILE_DIR ]; then
   echo "ERROR: missing Altirra profile directory"
   echo "(${PROFILE_DIR})"
   exit 1
fi

# - Set a default directory for storing profiles
# - Check for a profile file
#   - A profile file contains an ALTIRRA_PROFILE, and a list of disk images to
#     mount in ALTIRRA_DISK_IMGS
# - If no profile file is specified, or the specified profile file does not
#   exist, then list out the profile files in the profile directory

if [ $# -eq 0 ]; then
   echo "ERROR: missing profile filename argument"
   echo "Usage: ${0} <profile_filename>.txt"
   echo "Profiles available (${PROFILE_DIR}):"
   for PROFILE in $(ls ${PROFILE_DIR});
   do
      echo "- ${PROFILE}"
   done
   echo
   exit 1
fi

# - Read in the profile file, and parse out it's contents
PROFILE_FILE=$1
if [ ! -r ${PROFILE_DIR}/${PROFILE_FILE} ]; then
   echo "ERROR: profile file '${PROFILE_FILE} doesn't exist/is not readable"
   exit 1
fi
ALTIRRA_PROFILE_NAME=$(cat ${PROFILE_DIR}/${PROFILE_FILE} \
   | grep 'ALTIRRA_PROFILE_NAME' \
   | sed 's/^ALTIRRA_PROFILE_NAME=//')
echo "ALTIRRA_PROFILE_NAME: ${ALTIRRA_PROFILE_NAME}"
ALTIRRA_DISK_IMGS_LIST=$(cat ${PROFILE_DIR}/${PROFILE_FILE} \
   | grep 'ALTIRRA_DISK_IMAGES' \
   | sed 's/^ALTIRRA_DISK_IMAGES=//')
ALTIRRA_DISK_CMDS=""
for DISKIMG in $(echo $ALTIRRA_DISK_IMGS_LIST | tr ',' ' ');
do
   ALTIRRA_DISK_CMDS="${ALTIRRA_DISK_CMDS} /disk ${DISKIMG}"
done
echo "Disk images command: ${ALTIRRA_DISK_CMDS}"
# - Start Altirra with the parsed contents of the profile file (Altirra
#   profile, disk images to mount, etc.), and a possible portable INI file
#   filename

echo "Starting Altirra '${ALTIRRA_PROFILE}'..."
export WINEDEBUG="-all"
ALTIRRA_CMD="$WINE64_BIN \
   ${ALTIRRA_HOME}/Altirra64.exe \
   /portable \
   /d3d9 \
   /profile:${ALTIRRA_PROFILE_NAME} \
   $ALTIRRA_DISK_CMDS"
#echo "Altirra command: ${ALTIRRA_CMD}"
exec $ALTIRRA_CMD 2> ${ALTIRRA_HOME}/Altirra64.${ALTIRRA_PROFILE}.wine.log &
