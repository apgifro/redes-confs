# Serviços de Redes

## Gateway

- /etc/netplan/network.yaml
- ./nat.sh

## DNS I

- /etc/netplan/network.yaml
- /etc/dhcp/dhcpd.conf


- /etc/bind/named.conf.default-zones
- /etc/bind/named.conf.options
- /etc/bind/named.conf.local
- /etc/bind/lab/lab.interna
- /etc/bind/lab/rev.interna
- /etc/bind/lab/lab.externa
- /etc/bind/lab/rev.externa

## DNS II

- /etc/netplan/network.yaml

## Web

- /etc/netplan/network.yaml


## Comandos úteis

```
netplan try
netplan apply
resolvectl

systemctl restart bind9
journalctl -xeu named.service
named-checkzone lab.interna rev.interna
```
