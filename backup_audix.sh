#!/bin/sh

# script to backup the audix databases to SDGPROD

# mount SDGPROD

/usr/bin/ncpmount -S SDGPROD -U audix -P audix -V vol1 /mnt/sdgprod

# then copy the databases to SDGPROD

FILENAME=mysql.`date +%b%d%Y`.tar.gz

tar -czvf $FILENAME /var/lib/mysql

cp $FILENAME /mnt/sdgprod/USER/BRIAN/audix

rm -f $FILENAME

# then unmount and end

/usr/bin/ncpumount /mnt/sdgprod

exit 0
