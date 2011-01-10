#!/bin/bash

# looping over a list of files that contain spaces; how can you get around the
# shell interpreting the spaces in filenames as a shell delimter

test_function () {
    local FILES="${1}"
    echo "received: $FILES"

    #for FILE in $(IFS="\0" echo ${FILES});
    for FILE in $(IFS='|' echo ${FILES});
    do
        ls -ld "$FILE"
    done
} # test_function ()

TEMP_DIR=$(/bin/mktemp -d /dev/shm/filenames_test.XXXXX)
for FILE_NUM in $(seq 5);
do
    touch "${TEMP_DIR}/test file number ${FILE_NUM}"
done
#FILE_LIST=$(ls -1 ${TEMP_DIR} | tr '\n' '\0')
FILE_LIST=$(ls -1 ${TEMP_DIR} | tr '\n' '|')
test_function "${FILE_LIST}"

/bin/rm -rf $TEMP_DIR
exit 0
