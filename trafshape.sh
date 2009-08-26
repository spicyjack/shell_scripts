#!/bin/sh

# load traffic shaping rules into the kernel
# taken from my cribnotes at
# http://www.antlinux.com/pmwiki/pmwiki.php?n=AntLinux.LinuxTrafficShaping

PATH=/sbin:/bin
# 'tc' binary
TC_BIN=/sbin/tc
# external interface
ETH_DEV=eth0
# traffic shaping module to use
TRAF_MOD=sch_htb
# filter for the 1:10 class below
U32="tc filter add dev ${ETH_DEV} protocol ip parent 1:0 prio 1 u32"

if [ ! -f $TC_BIN ]; then
    echo "tc not found, exiting..."
    exit 0
fi

if [ $EUID -ne 0 ]; then 
    echo "Error: need to be root to use this script"
    exit 0;
fi
# a traffic shaping rule load function
load () {
    /sbin/modprobe $TRAF_MOD

    # load a root filter with heirarchical token bucket filter and the default
    # traffic being handled by class 30
    $TC_BIN qdisc add dev $ETH_DEV root handle 1: htb default 30

    #  add a subclass underneath the root class with the maximum amount of
    #  bandwidth available on this link
    $TC_BIN class add dev $ETH_DEV \
        parent 1:0 classid 1:1 htb rate 250kbit burst 10k

    # add a subclass below 1:1 for each specific service you want to filter;
    # HTTP MP3 streaming first as classid 1:10, with at least 170kbit minimum
    # and a 200kbit ceiling
    $TC_BIN class add dev $ETH_DEV \
        parent 1:1 classid 1:10 htb rate 190kbit ceil 300kbit burst 10k

    # then add the subclass for everything else
    $TC_BIN class add dev $ETH_DEV \
        parent 1:1 classid 1:30 htb rate 1kbit ceil 300kbit burst 15k

    # set up the fair queues
    $TC_BIN qdisc add dev $ETH_DEV parent 1:10 handle 10: sfq perturb 10
    $TC_BIN qdisc add dev $ETH_DEV parent 1:10 handle 30: sfq perturb 10

    # set up filters for the 1:10 class (MP3 stream)
    $U32 match ip src 129.46.88.196 match ip dport 8000 0xffff flowid 1:10

    # then filter for everything else
    $TC_BIN filter add dev $ETH_DEV protocol ip parent 1: prio 2 flowid 1:30
     
}

# a traffic shaping rule unload function
#unload () {
#
#}
case "$1" in
start|force-reload)
  echo -n "Loading traffic shaping rules"
  unload
  load
  echo "."
  ;;
restart|reload)
  echo -n "Unloading traffic shaping rules"
  unload
  load
  echo "."
  ;;
stop)
  unload
  echo "."
  ;;
status)
  echo " === Traffic Shaping Queue Disciplines ==="
  $TC_BIN qdisc show dev $ETH_DEV
  echo " === Traffic Shaping Classes ==="
  $TC_BIN class show dev $ETH_DEV
  echo " === Traffic Shaping Filters ==="
  $TC_BIN filter show dev $ETH_DEV
  ;;
*)
  echo "Usage: /etc/init.d/trafshape {start|stop|restart|reload|force-reload|status}"
  exit 1
esac

exit 0
