#!/bin/bash

# testing the -z (zero length) and -n (non-zero length) options to 'test'

TEST_VAR="foobarbaz"

echo "TEST_VAR is '${TEST_VAR}'"
if [ "${TEST_VAR/foo/}" != "foo" ]; then
    echo "TEST_VAR contains 'foo'"
else
    echo "TEST_VAR does not contain 'foo'"
fi
