#!/bin/sh

# ANSI Color Finder
# A Batch file written February 22, 1997
# converted to 'sh' shell script 01Sep2004
# by Brian Manning
# brian (at) antlinux.com

CLEAR=/usr/bin/clear

function normal()
{
    echo -n "[0;37;40m/          0;30       0    [0;30;47mBlack"
    echo -n "[0;37;40m                ;40       0    [0;37;40mBlack"
    echo "[0;37;40m          \\"
    echo -n "[0;37;40m/          0;31       4    [0;31;40mRed"
    echo -n "[0;37;40m                  ;41       4    [0;30;41mRed"
    echo "[0;37;40m            \\"
    echo -n "[0;37;40m/          0;32       2    [0;32;40mGreen"
    echo -n "[0;37;40m                ;42       2    [0;30;42mGreen"
    echo "[0;37;40m          \\"
    echo -n "[0;37;40m/          0;33       6    [0;33;40mYellow"
    echo -n "[0;37;40m               ;43       6    [0;30;43mYellow"
    echo "[0;37;40m         \\"
    echo -n "[0;37;40m/          0;34       1    [0;34;40mBlue"
    echo -n "[0;37;40m                 ;44       1    [0;30;44mBlue"
    echo "[0;37;40m           \\"
    echo -n "[0;37;40m/          0;35       5    [0;35;40mMagenta"
    echo -n "[0;37;40m              ;45       5    [0;30;45mMagenta"
    echo "[0;37;40m        \\"
    echo -n "[0;37;40m/          0;36       3    [0;36;40mCyan"
    echo -n "[0;37;40m                 ;46       3    [0;30;46mCyan"
    echo "[0;37;40m           \\"
    echo -n "[0;37;40m/          0;37       7    [0;37;40mWhite"
    echo -n "[0;37;40m                ;47       7    [0;30;47mWhite"
    echo "[0;37;40m          \\"
    echo -n "[0;37;40m/[0;32;40m=================== Press "X" to switch to "
    echo "[1;37;40mBright[0;32;40m Mode ========================[0;37;40m\\"
    echo -n "Press the [1;33;40mB[0;37;40m to switch to [1;37;40mBright"
    echo "[0;37;40m color or press [1;36;40mQ[0;37;40m to quit."
} # function normal

function bold()
{
    echo -n "[0;37;40m/          1;30       8    [1;30;47mBlack"
    echo -n "[0;37;40m                ;40       0    [0;37;40mBlack"
    echo "[0;37;40m          \\"
    echo -n "[0;37;40m/          1;31      12    [1;31;40mRed"
    echo -n "[0;37;40m                  ;41       4    [0;30;41mRed"
    echo "[0;37;40m            \\"
    echo -n "[0;37;40m/          1;32      10    [1;32;40mGreen"
    echo -n "[0;37;40m                ;42       2    [0;30;42mGreen"
    echo "[0;37;40m          \\"
    echo -n "[0;37;40m/          1;33      14    [1;33;40mYellow"
    echo -n "[0;37;40m               ;43      14    [0;30;43mYellow"
    echo "[0;37;40m         \\"
    echo -n "[0;37;40m/          1;34       9    [1;34;40mBlue"
    echo -n "[0;37;40m                 ;44       1    [0;30;44mBlue"
    echo "[0;37;40m           \\"
    echo -n "[0;37;40m/          1;35      13    [1;35;40mMagenta"
    echo -n "[0;37;40m              ;45       5    [0;30;45mMagenta"
    echo "[0;37;40m        \\"
    echo -n "[0;37;40m/          1;36      11    [1;36;40mCyan"
    echo -n "[0;37;40m                 ;46       3    [0;30;46mCyan"
    echo "[0;37;40m           \\"
    echo -n "[0;37;40m/          1;37      15    [1;37;40mWhite"
    echo -n "[0;37;40m                ;47       7    [0;30;47mWhite"
    echo "[0;37;40m          \\"
    echo -n "[0;37;40m/[0;32;40m=================== Press "X" to switch to "
    echo "[1;34;40mNormal[0;32;40m Mode ========================[0;37;40m\\"
    echo -n "Press the [1;33;40mN[0;37;40m to switch to [1;34;40mNormal"
    echo "[0;37;40m color or press [1;36;40mQ[0;37;40m to quit."
} # function bold()

function main()
{
    echo -n "[0;32;40m====================== [1;37;40mWelcome to Brian's "
    echo -n "[1;31;40mA[0;32;40mN[0;34;40mS[1;33;40mI[1;37;40m "
    echo "Color Finder[0;32;40m ==================="

    echo -n "[0;37;40m/   This batch program will help you choose colors for"
    echo "including in your       \\"
    echo -n "[0;37;40m/   batch programs and Config Menus in MS-DOS Version 5 and up,"
    echo "Windows 3.x    \\"
    echo -n "[0;37;40m/   and Windows 95.  The [1;31;40mA[0;32;40mN"
    echo -n "[0;34;40mS[1;33;40mI[0;37;40m.SYS driver [1;31;40mmust be loaded"
    echo "[0;37;40m in CONFIG.SYS for     \\"

    echo -n "[0;37;40m/   all this stuff to work!!!"
    echo "                                                 \\"

    echo -n "[0;37;40m/[0;32;40m=========== Usage esc[{a};{fg};{bk}m a-Attrib. "
    echo "fg-Fore bk- Back =============[0;37;40m\\"
    echo -n "[0;37;40m/      Press A key listed below to change the color of the "
    echo "sample text.       \\"

    echo -n "[0;37;40m/   -----------Foreground------------   "
    echo "------------Background-----------     \\"

    echo -n "[0;37;40m/         [Batch] [Config] Color Name         "
    echo "[Batch] [Config] Color Name     \\"
} # function main 

# run the main display function, then the normal function
$CLEAR
main
normal

while true; do
    read VAR
    case "$VAR" in
        n|N)  $CLEAR; main; normal;;
        b|B)  $CLEAR; main; bold;;
        q|Q)  $CLEAR; echo "[0;37;40mEnjoy!!!"; exit 0;;
    esac
done
