#!/bin/bash
FILE=$1
if [ "$FILE" = "" ]; then
    echo "Usage: gpgencrypt filename"
    exit 1
fi

    while ! gpg --encrypt --armor --sign \
        --default-recipient-self --encrypt-to 0xA20FE45E \
        <$1 >$1.gpg; do
        clear
        echo "Uh, please try again..."
        echo
    done 
echo " done."
