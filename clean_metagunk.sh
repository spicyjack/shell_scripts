#!/bin/bash

# clean out all of the metadata files that macOS likes to copy
if [ $(find . -name '._*' | wc -l) -gt 0 ]; then
   echo "Metadata files found..."
   find . -name '._*'
   echo "Clean metadata files? [Y/n]"
   read ANSWER
   if [ "x${ANSWER}" != 'xn' -o "x${ANSWER}" != 'xN' ]; then
      echo "Cleaning files..."
      find . -name '._*' -exec rm -f '{}' \;
   fi
else
   echo "No metagunk files found ('._*')"
fi
exit 0
