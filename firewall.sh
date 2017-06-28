#!/bin/bash

# Clear all rules
iptables -t nat -F
iptables -F

# Set all default policies to DROP
iptables -P INPUT DROP
iptables -P OUTPUT DROP
iptables -P FORWARD DROP

# NAT LAN to Internet
iptables -A POSTROUTING -t nat -o eth0 -s 192.168.0.0/24 -j MASQUERADE

# NAT Internet to DMZ
iptables -A PREROUTING -t nat -i eth0 -p tcp --dport 80 -j DNAT --to 10.10.10.9

# Allow traffic from LAN to INTERNET on  ports 80 (http), 443 (https), 53(dns)
iptables -A FORWARD -i eth1 -o eth0 -s 192.168.0.0/24 -p tcp --dport 80 -j ACCEPT
iptables -A FORWARD -i eth1 -o eth0 -s 192.168.0.0/24 -p tcp --dport 443 -j ACCEPT
iptables -A FORWARD -i eth1 -o eth0 -s 192.168.0.0/24 -d 200.129.79.61 -p udp --dport 53 -j ACCEPT

iptables -A FORWARD -i eth0 -o eth1 -d 192.168.0.0/24 -p tcp --sport 80 -j ACCEPT
iptables -A FORWARD -i eth0 -o eth1 -d 192.168.0.0/24 -p tcp --sport 443 -j ACCEPT
iptables -A FORWARD -i eth0 -o eth1 -d 192.168.0.0/24 -s 200.129.79.61 -p udp --sport 53 -j ACCEPT

# Allow traffic from INTERNET to DMZ on port 80 (http)
iptables -A FORWARD -i eth0 -o eth2 -d 10.10.10.9 -p tcp --dport 80 -j ACCEPT
iptables -A FORWARD -i eth2 -o eth0 -s 10.10.10.9 -p tcp --sport 80 -j ACCEPT

# Allow ping from LAN to ROUTER
iptables -A INPUT -i eth1 -s 192.168.0.0/24 -p icmp --icmp-type echo-request -j ACCEPT
iptables -A OUTPUT -o eth1 -d 192.168.0.0/24 -p icmp --icmp-type echo-reply -j ACCEPT

# List iptables
iptables -L
iptables -t nat -S

