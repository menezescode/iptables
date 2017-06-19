#!/bin/bash

# Flux iptables
iptables -F

# Set all default policies to ACCEPT
iptables -P INPUT ACCEPT
iptables -P FORWARD ACCEPT
iptables -P OUTPUT ACCEPT

# Block INPUT traffic on port 80
iptables -A INPUT -i eth0 -p tcp --sport 80 -j DROP

# List rules
iptables -L
