#!/bin/bash

# rede
sudo rm -rf /etc/netplan
sudo mkdir /etc/netplan
sudo cp network.yaml /etc/netplan
sudo netplan try
sudo netplan apply
echo '[Web] Rede configurada!'
