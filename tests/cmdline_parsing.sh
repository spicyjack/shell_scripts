#!/bin/sh

TEST_STRING="root=/dev/hda1 ro DEBUG=1 vol=vg0"

cmdline_parse () {
    # parse /proc/cmdline, looking for search string found in $1
    SEARCH=$1
    # reset the parsed flag; must do this here instead of inside the for loop,
    # or PARSED will get overwritten with each failure, which could happen
    # after the successful grep
    PARSED=''
    for VAR in $(echo ${TEST_STRING}); do
        echo "- searching $VAR"
        echo $VAR | grep "^${SEARCH}=" > /dev/null
        if [ $? -eq 0 ]; then
            echo "  - found ${SEARCH} in ${VAR}"
            PARSED=$(expr "${VAR}" : '.*=\(.*\)')
            echo "  - parsed string is $PARSED"
            break
        fi
    done
    echo "parsed string is ${PARSED}"
} # cmdline_parse()

echo -n "Enter in a string to parse: "
read ANSWER
cmdline_parse $ANSWER
