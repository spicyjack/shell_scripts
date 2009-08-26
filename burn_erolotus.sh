#!/bin/sh

# -Z | Burn an initial session to the selected device
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

DATE=$(date +%d%h%Y)

/usr/bin/growisofs -Z /dev/dvd -dvd-compat \
-r -v -T -J \
-A "erolotus.com website backup for ${DATE}" \
-publisher "http://www.erolotus.com" \
-p "Erol Otus" \
-V "eo.com-${DATE}" \
-m CVS \
-m *.iso \
-m lost+found \
-m TRANS.TBL \
-m index.html \
-graft-points \
devhtml/=/home/erolotus/devhtml \
oldhtml/=/home/erolotus/html \
gallery/=/home/erolotus/gallery \
g2data/=/home/erolotus/g2data/albums \
originals/=/home/erolotus/originals \
db_backups/=/home/erolotus/db_backups \
gallery_themes/=/home/antlinux/html/gallery/themes/eo/gallery_theme \
drupal/=/home/httpd/drupal/misc/drupal.css \
drupal/eodark/=/home/httpd/drupal/themes/eodark
