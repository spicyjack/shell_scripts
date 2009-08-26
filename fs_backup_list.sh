nice -n 19 /usr/bin/find /home -mount ! -path /home/ftp/other \
! -path /home/ssldocs/libro > ~/fs_list.txt
nice -n 19 /usr/bin/find /bin >> ~/fs_list.txt
nice -n 19 /usr/bin/find /boot >> ~/fs_list.txt
nice -n 19 /usr/bin/find /dev >> ~/fs_list.txt
nice -n 19 /usr/bin/find /etc >> ~/fs_list.txt
nice -n 19 /usr/bin/find /lib >> ~/fs_list.txt
nice -n 19 /usr/bin/find /root >> ~/fs_list.txt
nice -n 19 /usr/bin/find /sbin >> ~/fs_list.txt
nice -n 19 /usr/bin/find /usr >> ~/fs_list.txt
nice -n 19 /usr/bin/find /var >> ~/fs_list.txt
