#!/bin/bash

# testing the -z (zero length) and -n (non-zero length) options to 'test'

TEST_VAR=""

if [ "$TEST_VAR" = "foo" ]; then
    echo "TEST_VAR is 'foo'"
else
    echo "TEST_VAR is not 'foo'; TEST_VAR is '${TEST_VAR}'"
fi

TEST_VAR="foo"
if [ "$TEST_VAR" = "foo" ]; then
    echo "TEST_VAR is 'foo'"
else
    echo "TEST_VAR is not 'foo'; TEST_VAR is '${TEST_VAR}'"
fi
