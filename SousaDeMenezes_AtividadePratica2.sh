#!/bin/bash

# Set everything to ACCEPT
iptables -P INPUT ACCEPT
iptables -P FORWARD ACCEPT
iptables -P OUTPUT ACCEPT

# Clean all the added rules
iptables -F

# Drop default INPUT policy
iptables -P INPUT DROP

# Allow ICMP echo reply (PING)
iptables -A INPUT -i eth0 -p icmp --icmp-type 0 -j ACCEPT

# Allow incoming traffic on port 80 and 443 tcp (HTTP and HTTPS)
iptables -A INPUT -i eth0 -p tcp --sport 80 -j ACCEPT
iptables -A INPUT -i eth0 -p tcp --sport 443 -j ACCEPT

# Allow incoming traffic on port 53 udp (DNS)
iptables -A INPUT -i eth0 -p udp --sport 53 -j ACCEPT

# Log
iptables -A INPUT -i eth0 -j LOG --log-prefix "LOG: "

# Drop default FORWARD policy
iptables -P FORWARD DROP

# Drop default OUTPUT policy
iptables -P OUTPUT DROP

# List rules
iptables -L
