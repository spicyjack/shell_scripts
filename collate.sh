#!/bin/sh

# combines all files in a directory into one file for printing.  
# makes headers in between files

echo "* Homework for Brian Manning" > out.txt
echo "* Copyright (c) 2004 Brian Manning" >> out.txt
echo "* bmanning (at) qualcomm.com" >> out.txt
echo "* UoP IRN: 9000513889" >> out.txt
echo "* WEB410, Raul Calimlim">> out.txt

for x in `ls | grep -v CVS | grep -v png | grep -v sh| grep -v out.txt`
do
    echo >> out.txt
    echo "******************************************************" >> out.txt
    echo "* Filename: $x                                       *" >> out.txt
    echo "******************************************************" >> out.txt
    echo >> out.txt

    cat $x >> out.txt
done
