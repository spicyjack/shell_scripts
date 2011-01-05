#!/bin/bash

# testing using eval() to get the values of variables given only the name of
# the variable

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
