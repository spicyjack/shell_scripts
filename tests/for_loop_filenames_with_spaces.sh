#!/bin/bash

# looping over a list of files that contain spaces; how can you get around the
# shell interpreting the spaces in filenames as a shell delimter

# ideas:
# http://www.macgeekery.com/tips/cli/handling_filenames_with_spaces_in_bash

test_function () {
    local FILE="${1}"
    #local FILE="${@}"
    echo "received: ${FILE}"
    #echo "received: ${@}"

    #for FILE in $(IFS="\0" echo ${FILES});
    #for FILE in $(IFS='|' echo ${FILES});
    #for FILE in "$@";
    #do
        ls -ld "$FILE"
    #done
} # test_function ()

TEMP_DIR=$(/bin/mktemp -d /dev/shm/filenames_test.XXXXX)
for FILE_NUM in $(seq 5);
do
    touch "${TEMP_DIR}/test file number ${FILE_NUM}"
done
#FILE_LIST=$(ls -1 ${TEMP_DIR} | tr '\n' '\0')
#FILE_LIST=$(ls -1 ${TEMP_DIR} | tr '\n' '|')
#find $TEMP_DIR -name '* *' -print0 | xargs -0 test_function
#find $TEMP_DIR -name '* *' -print0 | xargs -0 -n 1 -I % echo % rocks 
find $TEMP_DIR -name '* *' | while read FILE
do 
    test_function "${FILE}"
done

/bin/rm -rf $TEMP_DIR
exit 0
