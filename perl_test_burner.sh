#!/bin/bash

# run one or more Perl test scripts multiple times

TEST_PATH=$1

echo "TEST_PATH is: $TEST_PATH"
if [ -z $TEST_PATH ]; then
   echo "Usage: $0 /path/to/test/file/or/dir"
   exit 1
fi

if [ -d $TEST_PATH ]; then
   TEST_FILES=$(find $TEST_PATH -name '*.t')
elif [ -f $TEST_PATH ]; then
   TEST_FILES=$TEST_PATH
fi

PASS=0
FAIL=0
for TEST_FILE in $TEST_FILES;
do
   TEST_BASE_FILENAME=$(basename $TEST_FILE)
   echo "-> Running '$TEST_BASE_FILENAME' 100 times"

   for TEST_COUNT in $(seq 1 100);
   do
      # write a test status line
      printf "%s:%3u -> pass: %2u; fail: %2u\n" \
         $TEST_BASE_FILENAME $TEST_COUNT $PASS $FAIL
      # create the test logfile
      TEST_LOGFILE=$(mktemp -t ${TEST_BASE_FILENAME}.XXXXXXXX)
      # run the test
      prove -cl $TEST_FILE > $TEST_LOGFILE 2>&1
      # mark the test as pass/fail
      if [ $? -eq 0 ]; then
         mv $TEST_LOGFILE ${TEST_LOGFILE}.pass.log
         PASS=$((PASS + 1))
      else
         mv $TEST_LOGFILE ${TEST_LOGFILE}.fail.log
         FAIL=$((FAIL + 1))
      fi
   done
done
