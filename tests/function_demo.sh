#!/bin/sh

# script to demonstrate returning a value from a function () call

demo () {
    return 2
} # function demo ()

demo
TEST=$?

echo "test was $TEST"

exit 0
