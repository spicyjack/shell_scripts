#!/bin/bash

# script to check for ripping errors in ripped FLAC files
CHECK_FILE="riplogs.txt"

check_for_errors () {
   local IFS=$'\t\n'
   for LINE in $(cat $CHECK_FILE);
   do
      # skip parsing $CHECK_FILE
      if [ $(echo $LINE | grep -c "${CHECK_FILE}") -gt 0 ]; then
         continue
      fi
      #echo "Checking file: $LINE"
      ERROR_COUNT=$(iconv -f utf-16 -t utf-8 "${LINE}" \
         | egrep -c "Inaccurate|ERROR")
      if [ $ERROR_COUNT -gt 0 ]; then
         # found errors
         echo "==> FILE: ${LINE}"
         iconv -f utf-16 -t utf-8 "${LINE}" \
            | egrep "Inaccurate|ERROR"
      fi
   done
}

# get a list of files to check
# the CD ripper that comes with dbPoweramp creates logfiles for each disc that
# is ripped; the log files are usually named "<Artist> - <Album>.txt"
find . -type f -name '*.txt' > $CHECK_FILE
check_for_errors
rm $CHECK_FILE
