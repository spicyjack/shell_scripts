#!/bin/sh

# burns a DVD with the contents from a specific directory

# -Z | Burn an initial session to the selected device
# -M | Merge a new session to an existing one
# -dvd-compat | Provide maximum media compatibility
# -r -T -v -J | Rock Ridge, Trans.Tbl, verbose, Joliet, and include all files
# -hfs | Create an ISO9660/HFS hybrid CD
# -apple | Create an ISO9660 CD with Apple's extensions
# -A | Application name
# -P | Publisher ID
# -p | Person responsible
# -x | exclude file/directory
# -b | boot image is boot.img
# -c | catalog file created 
# -V | Volume ID
# directory or file to create it from    
#-A "MAME 0.61 Disc 2: W-Z and Consoles/Doom" \

/usr/local/bin/growisofs -Z /dev/dvd -dvd-compat \
-r -v -T -apple \
-A "MAME 0.61 Disc 2: V-Z and Much More" \
-P "http://www.antlinux.com" \
-p "Brian Manning" \
-V "mame-0.61-2" \
-m lost+found \
-m TRANS.TBL \
/mnt/dosd/mame2/
