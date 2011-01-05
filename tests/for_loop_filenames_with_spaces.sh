#!/bin/bash

# looping over a list of files that contain spaces; how can you get around the
# shell interpreting the spaces in filenames as a shell delimter

test_function () {
    local FILES=$1
    echo "received: $FILES"

    #for FILE in $(IFS='|' echo ${FILES});
    for FILE in $(echo ${FILES} | awk -F'|' '{print $1}');
    do
        ls -ld $FILE
    done
} # test_function ()

SHELLINABOX=$(dpkg -L shellinabox | tr '\n' '|')
echo "shellinabox currently is:"
echo $SHELLINABOX
test_function "${SHELLINABOX}"
