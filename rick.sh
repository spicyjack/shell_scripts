#!/bin/sh

# script to copy files to/from a remote server
CD="/Applications/MacPorts/CocoaDialog.app/Contents/MacOS/CocoaDialog"

#$CD standard-inputbox --no-show --title 'Copy index.php to/from Observer' \
#    --no-newline  --informative-text 'Please enter your password:' \
#    --no-show --button1 'Next ->' --button2 'Cancel' --float

cmd_status () {
    # $1 is the return value from scp
    if [ $1 -eq 0 ]; then
        $CD ok-msgbox --no-cancel --text "Success!" --icon heart --float \
            --informative-text "The file copy was successful" > /dev/null
    else
        $CD ok-msgbox --no-cancel --text "FAILURE!" --icon x --float \
            --informative-text \
            "The file copy was unsuccessful" > /dev/null
    fi
}

RETURN=$($CD standard-dropdown --float --title 'Remote File Copy' \
    --text "Please Select an Option:" \
    --items "Copy files TO server" "Copy files FROM server" | tail -n 1)

if [ $RETURN -eq 0 ]; then
    /usr/bin/scp -q ~/index.php brian@antlinux.com:/home/bob/html
        
else
    /usr/bin/scp -q brian@antlinux.com:/home/bob/html/index.php ~ 
fi

cmd_status $?
