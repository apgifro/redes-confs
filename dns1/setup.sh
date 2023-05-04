#!/bin/bash

# rede
sudo rm -rf /etc/netplan
sudo mkdir /etc/netplan
sudo cp network.yaml /etc/netplan
sudo netplan try
sudo netplan apply
echo '[DNS1] Rede configurada!'

# dhcp
sudo apt install -y isc-dhcp-server
sudo rm /etc/dhcp/dhcpd.conf
sudo cp dhcp/dhcpd.conf /etc/dhcp/
sudo systemctl restart isc-dhcp-server
echo '[DNS1] DHCP configurado!'

# dns
sudo apt install -y bind9

sudo mkdir /etc/bind/backup
sudo mv /etc/bind/named.conf.default-zones /etc/bind/backup/
sudo mv /etc/bind/named.conf.options /etc/bind/backup/
sudo mv /etc/bind/named.conf.local /etc/bind/backup/

sudo cp bind/named.conf.default-zones /etc/bind/
sudo cp bind/named.conf.options /etc/bind/
sudo cp bind/named.conf.local /etc/bind

sudo mkdir /etc/bind/lab
sudo cp bind/lab.interna /etc/bind/lab/
sudo cp bind/rev.interna /etc/bind/lab/
sudo cp bind/lab.externa /etc/bind/lab/
sudo cp bind/rev.externa /etc/bind/lab/

sudo systemctl restart bind9
echo '[DNS1] DNS configurado!'