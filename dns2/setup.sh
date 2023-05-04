#!/bin/bash

# dns
sudo apt install -y bind9

sudo mkdir /etc/bind/backup
sudo mv /etc/bind/named.conf.default-zones /etc/bind/backup/
sudo mv /etc/bind/named.conf.local /etc/bind/backup/

sudo cp bind/named.conf.default-zones /etc/bind/
sudo cp bind/named.conf.local /etc/bind

echo '[DNS2] DNS secundário configurado!'

# rede
sudo rm -rf /etc/netplan
sudo mkdir /etc/netplan
sudo cp network.yaml /etc/netplan
sudo netplan try
sudo netplan apply
echo '[DNS2] Rede configurada!'