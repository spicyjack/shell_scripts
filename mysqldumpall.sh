#!/bin/sh

DATE=$(date +%Y-%m.%d%h)
OUTDIR="/home/crapola/db_backups"

for DIR in $(/usr/bin/find /var/lib/mysql -type d 2>/dev/null \
    | sed 's/^\/var\/lib\/mysql\///' | grep -v "/var/lib/mysql"); 
do
    echo "Creating dumpfile ${DIR}.${DATE}.sql.bz2"
    /usr/bin/mysqldump --add-drop-table --add-locks --all --quick \
        $DIR | /bin/bzip2 -9 --stdout --compress \
        > $OUTDIR/$DIR.$DATE.sql.bz2
done

#/bin/mv $OUTDIR/drup_erolotus* /home/erolotus/db_backups
#/bin/mv $OUTDIR/eo_gallery* /home/erolotus/db_backups
