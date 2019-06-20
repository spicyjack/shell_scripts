#!/bin/bash

# test what 'return' does inside of a function

test_function () {
   return 1
}

# call the function
test_function

# scrape the exit status (value of 'return')
EXIT_STATUS=$?

# test it
if [ $EXIT_STATUS -gt 0 ]; then
   echo "Test is true (exit status: $EXIT_STATUS)"
else
   echo "Test is false (exit status: $EXIT_STATUS)"
fi
