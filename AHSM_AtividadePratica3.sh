#!/bin/bash

# Get first input argument
ARG=$1

# Argument checking
if [ -z $ARG ]
then
	ARG="ACCEPT"
	echo "Set the argument [DROP REJECT or LOG] when calling the script."
	echo "Nothing happened..."
	echo ""
fi

# Flux iptables
iptables -F

# Set all default policies to ACCEPT
iptables -P INPUT ACCEPT
iptables -P FORWARD ACCEPT
iptables -P OUTPUT ACCEPT

# Block INPUT traffic on port 80
iptables -A INPUT -i eth0 -p tcp --sport 80 -j $ARG

# LOG SSH
iptables -A INPUT -i eth0 -p tcp --dport 22 -j LOG --log-prefix "SSH LOG:"

# Block INPUT traffic on port 22
iptables -A INPUT -i eth0 -p tcp --dport 22 -j DROP

# List rules
iptables -L
