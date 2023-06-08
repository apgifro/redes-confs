#!/bin/bash

# rede
sudo rm -rf /etc/netplan
sudo mkdir /etc/netplan
sudo cp network.yaml /etc/netplan
sudo netplan apply
echo '[Gateway] Rede configurada!'

# firewall
sudo chmod +x nat.sh
sudo ./nat.sh
echo '[Gateway] NAT ativo!'