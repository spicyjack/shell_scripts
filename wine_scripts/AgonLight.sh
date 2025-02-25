#!/bin/bash

# run AgonLight under WINE
AGONLIGHT_VERSION="v0.9.69"
AGONLIGHT_HOME="${HOME}/Working/Single_Board_Computers/Agon_light"
AGONLIGHT_HOME="${AGONLIGHT_HOME}/fab-agon-emulator-${AGONLIGHT_VERSION}-macos"
AGONLIGHT_BIN="fab-agon-emulator"

export PATH="/opt/homebrew/bin:/opt/homebrew/sbin:${PATH}"

if [ ! -e "${AGONLIGHT_HOME}/${AGONLIGHT_BIN}" ]; then
   echo "ERROR: can't find '${AGONLIGHT_BIN}' binary!"
   echo " - Searched directory '${AGONLIGHT_HOME}'"
   exit 1
fi

START_PWD=${PWD}
cd ${AGONLIGHT_HOME}
$AGONLIGHT_BIN \
   2> ${AGONLIGHT_HOME}/${AGONLIGHT_BIN}.exe.wine.log &
cd ${START_PWD}
