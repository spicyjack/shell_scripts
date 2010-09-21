for CMD in lspci 'lspci -v' lsmod 'df -h' 'sudo fdisk -l /dev/sda'
    '/sbin/iwconfig wlan0' '/sbin/ifconfig wlan0' '/sbin/ifconfig eth0'
    'netstat -rn'; 
do  
    echo "===== $CMD =====" >> host_info.txt;
    $CMD >> host_info.txt; 
done
