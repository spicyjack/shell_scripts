#!/bin/bash

# testing the -z (zero length) and -n (non-zero length) options to 'test'

TEST_VAR=""

if [ -z $TEST_VAR ]; then
    echo "TEST_VAR is zero length"
else
    echo "-z TEST_VAR failed; TEST_VAR is '${TEST_VAR}'"
fi

TEST_VAR="foo"

if [ -n $TEST_VAR ]; then
    echo "TEST_VAR is non-zero length; '${TEST_VAR}'"
else
    echo "-n TEST_VAR failed; TEST_VAR is '${TEST_VAR}'"
fi

