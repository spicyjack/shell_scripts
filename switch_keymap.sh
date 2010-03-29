#!/bin/sh

# switch the keymaps in X

TEMPFILE=/tmp/switch_keymap-$USER
DATE=$(date)
DEFAULT_KEYMAP="pc+us"
ALTERNATE_KEYMAP="pc+ru"

if [ -r $TEMPFILE ]; then
    # remove the tempfile
    rm $TEMPFILE
    # warn
    echo "Switching to keymap $DEFAULT_KEYMAP"
    # switch to the default
    setxkbmap $DEFAULT_KEYMAP
else
    # warn
    echo "Switching to keymap $ALTERNATE_KEYMAP"
    # switch it
    setxkbmap $ALTERNATE_KEYMAP
    echo $DATE > $TEMPFILE
fi
