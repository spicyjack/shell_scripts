#!/bin/sh

        echo "Execute debug shell? [Y/n]"
        read ANSWER 
        if [ "x${ANSWER}" != "xn" -a "x${ANSWER}" != "xN" ]; then
            echo "answer was '${ANSWER}'"
            echo; echo
            echo "Running /bin/sh (NetBSD ash Shell)"
            exec /bin/sh
            exit 1 # shouldn't get here
        fi # if [ "${ANSWER}" = "y" -o "${ANSWER}" = "Y" ];
