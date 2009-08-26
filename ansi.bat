@echo off
set bold=false
:start
cls
REM ANSI Color Finder
REM A Batch file written February 22, 1997
REM by Brian Manning
REM brian (at) sunset-cliffs.org
REM
REM
echo [0;32;40m========================[1;37;40mWelcome to Brian's [1;31;40mA[0;32;40mN[0;34;40mS[1;33;40mI[1;37;40m Color Finder[0;32;40m===================
echo [0;37;40m/   This batch program will help you choose colors for including in your      \
echo [0;37;40m/   batch programs and Config Menus in MS-DOS Version 5 and up, Windows 3.x   \
echo [0;37;40m/   and Windows 95.  The [1;31;40mA[0;32;40mN[0;34;40mS[1;33;40mI[0;37;40m.SYS driver [1;31;40mmust be loaded[0;37;40m in CONFIG.SYS for     \
echo [0;37;40m/   all this stuff to work!!!                                                 \
echo [0;37;40m/[0;32;40m=========== Usage esc[{a};{fg};{bk}m a-Attrib. fg-Fore bk- Back =============[0;37;40m\
echo [0;37;40m/      Press A key listed below to change the color of the sample text.       \
echo [0;37;40m/   -----------Foreground------------   ------------Background-----------     \
echo [0;37;40m/         [Batch] [Config] Color Name         [Batch] [Config] Color Name     \
if %bold%==false echo [0;37;40m/          0;30       0    [0;30;47mBlack[0;37;40m                ;40       0    [0;37;40mBlack[0;37;40m          \
if %bold%==false echo [0;37;40m/          0;31       4    [0;31;40mRed[0;37;40m                  ;41       4    [0;30;41mRed[0;37;40m            \
if %bold%==false echo [0;37;40m/          0;32       2    [0;32;40mGreen[0;37;40m                ;42       2    [0;30;42mGreen[0;37;40m          \
if %bold%==false echo [0;37;40m/          0;33       6    [0;33;40mYellow[0;37;40m               ;43       6    [0;30;43mYellow[0;37;40m         \
if %bold%==false echo [0;37;40m/          0;34       1    [0;34;40mBlue[0;37;40m                 ;44       1    [0;30;44mBlue[0;37;40m           \
if %bold%==false echo [0;37;40m/          0;35       5    [0;35;40mMagenta[0;37;40m              ;45       5    [0;30;45mMagenta[0;37;40m        \
if %bold%==false echo [0;37;40m/          0;36       3    [0;36;40mCyan[0;37;40m                 ;46       3    [0;30;46mCyan[0;37;40m           \
if %bold%==false echo [0;37;40m/          0;37       7    [0;37;40mWhite[0;37;40m                ;47       7    [0;30;47mWhite[0;37;40m          \
if %bold%==false echo [0;37;40m/[0;32;40m===================Press "X" to switch to [1;37;40mBright[0;32;40m Mode========================[0;37;40m\
if %bold%==false choice /c:xq Press the [1;33;40mX[0;37;40m to switch to [1;37;40mBright[0;37;40m color or press [1;36;40mQ[0;37;40m to quit.
if %bold%==true echo [0;37;40m/          1;30       8    [1;30;47mBlack[0;37;40m                ;40       0    [0;37;40mBlack[0;37;40m          \
if %bold%==true echo [0;37;40m/          1;31      12    [1;31;40mRed[0;37;40m                  ;41       4    [0;30;41mRed[0;37;40m            \
if %bold%==true echo [0;37;40m/          1;32      10    [1;32;40mGreen[0;37;40m                ;42       2    [0;30;42mGreen[0;37;40m          \
if %bold%==true echo [0;37;40m/          1;33      14    [1;33;40mYellow[0;37;40m               ;43      14    [0;30;43mYellow[0;37;40m         \
if %bold%==true echo [0;37;40m/          1;34       9    [1;34;40mBlue[0;37;40m                 ;44       1    [0;30;44mBlue[0;37;40m           \
if %bold%==true echo [0;37;40m/          1;35      13    [1;35;40mMagenta[0;37;40m              ;45       5    [0;30;45mMagenta[0;37;40m        \
if %bold%==true echo [0;37;40m/          1;36      11    [1;36;40mCyan[0;37;40m                 ;46       3    [0;30;46mCyan[0;37;40m           \
if %bold%==true echo [0;37;40m/          1;37      15    [1;37;40mWhite[0;37;40m                ;47       7    [0;30;47mWhite[0;37;40m          \
if %bold%==true echo [0;37;40m/[0;32;40m===================Press "X" to switch to [1;34;40mNormal[0;32;40m Mode========================[0;37;40m\
if %bold%==true choice /c:xq Press the [1;33;40mX[0;37;40m to switch to [1;34;40mNormal[0;37;40m color or press [1;36;40mQ[0;37;40m to quit.
if errorlevel 2 goto end
if %bold%==true goto setboldfalse
set bold=true
goto start

:setboldfalse
set bold=false
goto start

:end
cls
echo [0;37;40Enjoy!!!
