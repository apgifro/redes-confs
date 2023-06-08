#!/bin/bash

REDE=172.16.1.0/24
HOST=192.168.56.1
GW1=192.168.56.2
GW2=192.168.56.3

echo "1" > /proc/sys/net/ipv4/ip_forward
iptables -t nat -A POSTROUTING -s $REDE -j MASQUERADE

DNS1=172.16.1.2
iptables -A FORWARD -p tcp -s $HOST -d $DNS1 --dport 22 -j ACCEPT
iptables -A FORWARD -p tcp -s $DNS1 -d $HOST --sport 22 -j ACCEPT
iptables -t nat -A PREROUTING -p tcp -s $HOST -d $GW1 --dport 52000 -j DNAT --to $DNS1:22

iptables -A FORWARD -p udp -s $HOST -d $DNS1 --dport 53 -j ACCEPT
iptables -A FORWARD -p udp -s $DNS1 -d $HOST --sport 53 -j ACCEPT
iptables -t nat -A PREROUTING -p udp -s $HOST -d $GW1 --dport 53 -j DNAT --to $DNS1:53

DNS2=172.16.1.3
iptables -A FORWARD -p tcp -s $HOST -d $DNS2 --dport 22 -j ACCEPT
iptables -A FORWARD -p tcp -s $DNS2 -d $HOST --sport 22 -j ACCEPT
iptables -t nat -A PREROUTING -p tcp -s $HOST -d $GW1 --dport 53000 -j DNAT --to $DNS2:22

iptables -A FORWARD -p udp -s $HOST -d $DNS2 --dport 53 -j ACCEPT
iptables -A FORWARD -p udp -s $DNS2 -d $HOST --sport 53 -j ACCEPT
iptables -t nat -A PREROUTING -p udp -s $HOST -d $GW2 --dport 53 -j DNAT --to $DNS2:53

WEB=172.16.1.4
iptables -A FORWARD -p tcp -s $HOST -d $WEB --dport 22 -j ACCEPT
iptables -A FORWARD -p tcp -s $WEB -d $HOST --sport 22 -j ACCEPT
iptables -t nat -A PREROUTING -p tcp -s $HOST -d $GW1 --dport 54000 -j DNAT --to $WEB:22

iptables -A FORWARD -p tcp -s $HOST -d $WEB --dport 443 -j ACCEPT
iptables -A FORWARD -p tcp -s $WEB -d $HOST --sport 443 -j ACCEPT
iptables -t nat -A PREROUTING -p tcp -s $HOST -d $GW1 --dport 443 -j DNAT --to $WEB:443

iptables -A FORWARD -p tcp -s $HOST -d $WEB --dport 80 -j ACCEPT
iptables -A FORWARD -p tcp -s $WEB -d $HOST --sport 80 -j ACCEPT
iptables -t nat -A PREROUTING -p tcp -s $HOST -d $GW1 --dport 80 -j DNAT --to $WEB:80

STORAGE=172.16.1.5
iptables -A FORWARD -p tcp -s $HOST -d $STORAGE --dport 22 -j ACCEPT
iptables -A FORWARD -p tcp -s $STORAGE -d $HOST --sport 22 -j ACCEPT
iptables -t nat -A PREROUTING -p tcp -s $HOST -d $GW1 --dport 55000 -j DNAT --to $STORAGE:22