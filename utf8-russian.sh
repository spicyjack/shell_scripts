#!/bin/sh
DIALOG=$(which dialog)
if [ ! $DIALOG ]; then
    DIALOG=$(which whiptail)
    if [ ! $DIALOG ]; then
        echo "ERROR: no dialog-type binary available for user interaction!"
        echo "Exiting installer..."
        exit 1
    fi # if [ ! $DIALOG ]
fi # if [ ! $DIALOG ]

TEXT="йцкегшщзхъёфывапролджэячсмитьбю"
echo $TEXT
