#!/bin/sh

# binaries
IPTABLES=/sbin/iptables 
MODPROBE=/sbin/modprobe 

# other script variables
EXT_IF=eth0
EXT_IP="65.119.16.218"
INT_IF=eth1

# the name of the chain to use for filtering
FILTER="filterchain"
# special chain to use for dropping bad mail hosts
MAILCHK="MAILCHECK"
MAILDROP="MAILDROP"

# what do we need to do?
MODE=${1}
BLOCKHOST=${2}
                                                                                
case "${MODE}" in
    'oldstart') # set up the filter/nat rules
		# start by loading the correct modules
		${MODPROBE} ip_tables >> /var/log/iptables.log 2>&1
		${MODPROBE} iptable_nat >> /var/log/iptables.log 2>&1
		${MODPROBE} ipt_REJECT >> /var/log/iptables.log 2>&1
		${MODPROBE} ip_conntrack_ftp >> /var/log/iptables.log 2>&1
		${MODPROBE} ip_nat_ftp >> /var/log/iptables.log 2>&1

		##### Packet Filtering and NAT #####
		# Packet filtering rules are applied to this host.  NAT rules are
		# applied to other hosts that wish to send packets across this host.
		# The two sets of rules can be considered completely separate from each
		# other, however, you need to be careful when constructing filter rules
		# that you allow for packets from internal hosts that are meant to
		# reach the external network, as well as packets that have been
		# translated from their external IP's to internal IP's.  NAT gets
		# applied before filtering, so you'll be filtering on packets that the
		# NAT chain has already had it's hands on

		##### NAT - Network Address Translation #####
		# PREROUTING rules are applied prior to INPUT rules
		# POSTROUTING rules are applied after OUTPUT rules
		# PREROUTING and POSTROUTING are attatched to the 'nat' table, so we'll
		# put that stuff in it's own section for each private network host
		# we're providing NAT for.  If the PREROUTING rule changes an IP
		# address, then the ALLOW/REJECT rules below will need to be set to
		# apply themselves to the new changed IP address		

		##### PACKET FILTERING #####
		# route traffic destined for the INPUT and FORWARD chains through a
		# custom chain so we can apply filters to it
		# set up the default policies
		# this will cover any packets that don't match the rules below
		# *NOTE*
		# most of the rules below lack the '-t filter' switch; that's the
		# default behaivor for iptables when there is no table specified with
		# the '-t' switch
		#${IPTABLES} -t filter -P INPUT DROP
		#${IPTABLES} -t filter -P OUTPUT REJECT
		#${IPTABLES} -t filter -P FORWARD DROP

		# masquerade outbound packets from internal hosts
		# for dynamic IP addresses
		#${IPTABLES} -t nat -A POSTROUTING -o ${EXT_IF} -j MASQUERADE
		# for static IP addresses

		${IPTABLES} -t nat -A POSTROUTING -o ${EXT_IF} -j SNAT --to ${EXT_IP}
		${IPTABLES} -t nat -A POSTROUTING -o ${EXT_IF} \
            -j LOG --log-prefix "postroute from internal:"
        # add a filter rule for forwarding packets
		#${IPTABLES} -t filter -A FORWARD -s 192.168.7.0/24 -j LOG \
        #    --log-prefix "forward from internal:"
		#${IPTABLES} -t filter -A FORWARD -s 192.168.7.0/24 -j ACCEPT

        ### DEFAULT ALLOW RULES ###
        # always allow localhost traffic 
        ${IPTABLES} -A INPUT -i lo -s 127.0.0.1/32 -d 127.0.0.1/32 -j ACCEPT 

		### BLOCK CHAIN ###
		# create a new chain 
		${IPTABLES} -N ${FILTER}
        ${IPTABLES} -N ${MAILCHK}
		# then send everything to it
		#${IPTABLES} -A INPUT ! -s 192.168.7.0/24 -j ${FILTER}
        # send packets to be forwarded through the filterchain table
		${IPTABLES} -A FORWARD -j ${FILTER}
		
        ### DEFAULT DROP RULES ###
		# now set up some rules on what we will drop
		# these rules are for the host machine
        # anything for port 25 should traverse the mailblock chain
		${IPTABLES} -A ${FILTER} -p tcp -d ${EXT_IP} --dport 25 -j mailblock
        ${IPTABLES} -A ${FILTER} -p udp -d ${EXT_IP} --dport 65:69 -j DROP
		${IPTABLES} -A ${FILTER} -p tcp -d ${EXT_IP} --dport 111 -j DROP
		${IPTABLES} -A ${FILTER} -p tcp -d ${EXT_IP} --dport 123 -j DROP
		${IPTABLES} -A ${FILTER} -p udp -d ${EXT_IP} --dport 123 -j DROP
		${IPTABLES} -A ${FILTER} -p tcp -d ${EXT_IP} --dport 135:139 -j DROP
		${IPTABLES} -A ${FILTER} -p udp -d ${EXT_IP} --dport 135:139 -j DROP
		${IPTABLES} -A ${FILTER} -p tcp -d ${EXT_IP} --dport 143 -j DROP
		${IPTABLES} -A ${FILTER} -p tcp -d ${EXT_IP} --dport 515 -j DROP
		${IPTABLES} -A ${FILTER} -p tcp -d ${EXT_IP} --dport 901 -j DROP
		${IPTABLES} -A ${FILTER} -p udp -d ${EXT_IP} --dport 2049 -j DROP
		${IPTABLES} -A ${FILTER} -p tcp -d ${EXT_IP} --dport 3306 -j DROP
		${IPTABLES} -A ${FILTER} -p tcp -d ${EXT_IP} --dport 4080 -j DROP
		${IPTABLES} -A ${FILTER} -p tcp -d ${EXT_IP} --dport 5432 -j DROP
		${IPTABLES} -A ${FILTER} -p tcp -d ${EXT_IP} --dport 7999 -j DROP
        
		##### NAT HOST PACKET MANGLING #####
		# map (and allow traffic from) external ports to internal hosts and
		# ports.  The sequence below goes NAT then filter, as the filter will
		# be applied after any NAT that takes place to a packet

		# IpItek on ${IPI_IP}
		# HTTP - port 1080 -> 80 TCP - NAT
		#${IPTABLES} -t nat -A PREROUTING -p tcp --dport 1080 -i ${EXT_IF} \
		#	-j DNAT --to ${IPI_IP}:80

		#${IPTABLES} -A ${FILTER} -p tcp -d ${IPI_IP} --dport 80 -j LOG \
		#	--log-prefix "IpItek->80/TCP: "
		# HTTP - port 80 TCP - filter
		#${IPTABLES} -A ${FILTER} -p tcp -d ${IPI_IP} --dport 80 -j ACCEPT

		# debugging use
		#${IPTABLES} -t nat -A PREROUTING -p tcp --dport 3022 -i ${EXT_IF} \
		#	-j DNAT --to ${MIN_IP}:22		
		# HTTP - port 22 TCP - filter
		#${IPTABLES} -A ${FILTER} -p tcp -d ${MIN_IP} --dport 22 -j ACCEPT

		# some rules that cover more generic traffic
		# let pings out, accept established and related connections, let new
		# connections from the internal network back out
		${IPTABLES} -A OUTPUT -p icmp -m state --state INVALID -j DROP
		${IPTABLES} -A ${FILTER} -m state --state RELATED,ESTABLISHED -j ACCEPT
		${IPTABLES} -A ${FILTER} -i ! ${EXT_IF} -m state --state NEW -j ACCEPT
        ${IPTABLES} -A ${FILTER} -i ${EXT_IF} -m limit \
            -j LOG --log-prefix "Bad packet from EXT_IF:"
        ${IPTABLES} -A ${FILTER} -i ${EXT_IF} -m limit \
            -j LOG --log-prefix "Bad packet not from EXT_IF:"
        #${IPTABLES} -A FORWARD -m state --state NEW,INVALID -j DROP
		#${IPTABLES} -A ${FILTER} -i ! ${EXT_IF} -m state --state NEW -j LOG \
		#	--log-prefix "new state packet match: "
		# if the packet has not already matched a rule in this chain, then send
		# it off to the great bit bucket in the sky
		#${IPTABLES} -A ${FILTER} -j DROP

		# and finally, enable packet forwarding in the kernel
		# this will freely forward packets across all network interfaces; it's
		# up to the NAT filter to do something with them once that happens
		echo 1 > /proc/sys/net/ipv4/ip_forward

    ;;
    'stop') # use mysqladmin to shut the server down
        # save the rules first
        /etc/init.d/${0} save
		# disable IP forwarding in the kernel
		echo 0 > /proc/sys/net/ipv4/ip_forward
		# remove the rules from PRE/POST routing and filtering; using ipchains
		# -F without a chain name will flush all chains in that table
		${IPTABLES} -t nat -F 
		${IPTABLES} -t filter -F
		${IPTABLES} -F ${FILTER}
		${IPTABLES} -F ${MAILCHK}
        ${IPTABLES} -F ${MAILDROP}
		${IPTABLES} -X ${FILTER}
		${IPTABLES} -X ${MAILCHK}
        ${IPTABLES} -X ${MAILDROP}
        ${IPTABLES} -P INPUT ACCEPT
		${IPTABLES} -P FORWARD ACCEPT

    ;;
    'start') # new start action
        /etc/init.d/${0} restore
		echo 1 > /proc/sys/net/ipv4/ip_forward
    ;;
    'restart') # restart the server
        /etc/init.d/${0} stop
        /etc/init.d/${0} start
    ;;
	'status') # dump the iptables rules for filter and nat tables
		echo "=============== NAT TABLE ================"
		${IPTABLES} -t nat -L -n --line-numbers
		echo "=============== FILTER TABLE ================"
		${IPTABLES} -t filter -L -n --line-numbers
	;;
    'mailblock') # block mail from this host
        ${IPTABLES} -A MAILCHECK -s ${BLOCKHOST} -d 65.119.16.0/24 \
            -p tcp --dport 25 -j MAILDROP
    ;;
    'save') # save the current tables
        /sbin/iptables-save > /etc/iptables.rules
    ;;
    'restore') # restore the current tables
       /sbin/iptables-restore < /etc/iptables.rules
    ;;
esac

