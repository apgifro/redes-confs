# Máquinas configuradas

- Gateway
- DNS I (DHCP)
- DNS II
- Web

## Gateway

### /etc/netplan/network.yaml
```
network:
  ethernets:
    enp0s3:
      dhcp4: true
    enp0s8:
      addresses:
      - 192.168.100.1/24
      nameservers:
        addresses: []
        search: []
    enp0s9:
      addresses:
      - 192.168.0.102/24
      nameservers:
        addresses: []
        search: []
  version: 2
```

### ./nat.sh
```
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
```


## DNS I

### /etc/netplan/network.yaml
```
network:
  ethernets:
    enp0s3:
      addresses:
      - 192.168.100.2/24
      nameservers:
        addresses: [8.8.8.8]
        search: []
      routes:
      - to: default
        via: 192.168.100.1
  version: 2
```

### /etc/dhcp/dhcpd.conf
```
subnet 192.168.100.0 netmask 255.255.255.0 {
        range 192.168.100.10 192.168.100.19;
        option domain-name-servers 192.168.100.2, 192.168.100.3, 8.8.8.8;
        option domain-name "lab.lan";
        option subnet-mask 255.255.255.0;
        option routers 192.168.100.1;
        option broadcast-address 192.168.100.255;
        default-lease-time 120;
        max-lease-time 7200;
}
```


## DNS II

### /etc/netplan/network.yaml
```
network:                                           
  ethernets:                                       
    enp0s3:                                        
      addresses:                                   
      - 192.168.100.3/24                           
      nameservers:                                 
        addresses: []                              
        search: []           
      routes:                
      - to: default          
        via: 192.168.100.1   
  version: 2
```
