#!/bin/bash

# testing the -z (zero length) and -n (non-zero length) options to 'test'

TEST_VAR="foo"

test_function () {
    local TEST_ARG=$1

    eval 'VAL=$'${TEST_ARG}
    echo "TEST_ARG = ${TEST_ARG}"
    echo "VAL = ${VAL}"
} # test_function ()

test_function TEST_VAR
TEST_VAR="bar"
test_function TEST_VAR
