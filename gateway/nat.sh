#!/bin/bash

# Acesso a internet pelos clientes
REDE=192.168.100.0/24
echo "1" > /proc/sys/net/ipv4/ip_forward
iptables -t nat -A POSTROUTING -s $REDE -j MASQUERADE

# Endereço da minha rede local
HOST=192.168.0.101
GATEWAY=192.168.0.102

# DNS I
DNS1=192.168.100.2
iptables -A FORWARD -p tcp -s $HOST -d $DNS1 --dport 22 -j ACCEPT
iptables -A FORWARD -p tcp -s $DNS1 -d $HOST --sport 22 -j ACCEPT
iptables -t nat -A PREROUTING -p tcp -s $HOST -d $GATEWAY --dport 52000 -j DNAT --to $DNS1:22

# DNS II
DNS2=192.168.100.3
iptables -A FORWARD -p tcp -s $HOST -d $DNS2 --dport 22 -j ACCEPT
iptables -A FORWARD -p tcp -s $DNS2 -d $HOST --sport 22 -j ACCEPT
iptables -t nat -A PREROUTING -p tcp -s $HOST -d $GATEWAY --dport 53000 -j DNAT --to $DNS2:22

# WEB
WEB=192.168.100.4
iptables -A FORWARD -p tcp -s $HOST -d $WEB --dport 22 -j ACCEPT
iptables -A FORWARD -p tcp -s $WEB -d $HOST --sport 22 -j ACCEPT
iptables -t nat -A PREROUTING -p tcp -s $HOST -d $GATEWAY --dport 54000 -j DNAT --to $WEB:22