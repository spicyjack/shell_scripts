#!/bin/sh

# script to parse the google code download lists page

wget -O - http://code.google.com/p/camelbox/downloads/list \
    | grep -A 1 "vt col_4" | less
