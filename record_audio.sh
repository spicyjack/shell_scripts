#!/bin/sh

# records audio for a length of time specified by $1
/usr/bin/sound-recorder -c 2 -s 48000 -b 16 -P \
    -S 390:00 -f wav my_morning_jacket.wav -q
