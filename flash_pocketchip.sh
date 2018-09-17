#!/bin/bash

# flash a pocketchip with the binaries in the CHIP_BINS_DIR directory
CHIP_BINS_DIR="${HOME}/stable-pocketchip-b126"

FEL='sudo sunxi-fel' \
  FASTBOOT='sudo fastboot' \
  SNIB=false \
  ${HOME}/src/chip-sdk.git/CHIP-tools/chip-update-firmware.sh \
  -L $CHIP_BINS_DIR
