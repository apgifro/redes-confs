# Máquinas configuradas

- Gateway
- DNS I (DHCP e DNS)
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
        addresses: [192.168.100.2]
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
        addresses: [192.168.100.2]
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

### /etc/bind/named.conf.default-zones

```
view "all" {
        match-clients { none; };
        zone "." {
                type hint;
                file "/usr/share/dns/root.hints";
        };
        zone "localhost" {
                type master;
                file "/etc/bind/db.local";
        };
        zone "127.in-addr.arpa" {
                type master;
                file "/etc/bind/db.127";
        };
        zone "0.in-addr.arpa" {
                type master;
                file "/etc/bind/db.0";
        };
        zone "255.in-addr.arpa" {
                type master;
                file "/etc/bind/db.255";
        };
};
```

### /etc/bind/named.conf.options
```
options {                        
  directory "/var/cache/bind";   
  version "not available";       
  dnssec-validation no;          
  allow-query { any; };          
  allow-transfer { any; };       
  notify yes;                    
  also-notify { 192.168.100.3; };
  listen-on-v6 { any; };         
  forwarders {                   
                8.8.8.8;         
  };                             
};
```

### /etc/bind/named.conf.local

```
acl "lab" {              
        192.168.100.0/24;
};                       

view "externa" IN {
  match-clients { !lab; any; };
        zone "lab.lan" {
                type master;
                file "/etc/bind/lab/lab.externa";
                allow-transfer { 192.168.0.103; };
        };

        zone "0.168.192.in-addr.arpa" {
                type master;
                file "/etc/bind/lab/rev.externa";
                allow-transfer { 192.168.0.103; };
        };
};

view "interna" IN {
   match-clients { lab; any; };
        zone "lab.lan" {
          type master;
          file "/etc/bind/lab/lab.interna";
        };
        zone "100.168.192.in-addr.arpa" {
          type master;
          file "/etc/bind/lab/rev.interna";
        };
};
```

### /etc/bind/lab/lab.interna

```
$TTL    604800
@       IN      SOA     dns1.lab.lan. alexandre.lab.lan. (
                              1         ; Serial
                         604800         ; Refresh
                          86400         ; Retry
                        2419200         ; Expire
                         604800 )       ; Negative Cache TTL
@       IN      NS      dns1.lab.lan.
@       IN      NS      dns2.lab.lan.

@       IN      A       192.168.100.2
@       IN      A       192.168.100.3

dns1    IN      A       192.168.100.2
dns2    IN      A       192.168.100.3

web     IN      A       192.168.100.4

ns1     IN      CNAME   dns1.lab.lan.
ns2     IN      A       192.168.100.3

www     IN      CNAME   web
portal  IN      A       192.168.100.3
```

### /etc/bind/lab/rev.interna

```
$TTL    604800
@       IN      SOA     dns1.lab.lan. alexandre.lab.lan. (
                              1         ; Serial
                         604800         ; Refresh
                          86400         ; Retry
                        2419200         ; Expire
                         604800 )       ; Negative Cache TTL
;
@       IN      NS      lab.lan.
ns1     IN      A       192.168.100.2
ns2     IN      A       192.168.100.3
2       IN      PTR     dns1.lab.lan.
3       IN      PTR     dns2.lab.lan.
4       IN      PTR     web.lab.lan.
```

### /etc/bind/lab/lab.externa

```
@       IN      SOA     dns1.lab.lan. alexandre.lab.lan. (
                              1         ; Serial
                         604800         ; Refresh
                          86400         ; Retry
                        2419200         ; Expire
                         604800 )       ; Negative Cache TTL
;
@       IN      NS      dns1.lab.lan.
@       IN      NS      dns2.lab.lan.

@       IN      A       192.168.0.2
@       IN      A       192.168.0.3

dns1    IN      A       192.168.0.2
dns2    IN      A       192.168.0.3
dns     IN      CNAME   dns1.lab.lan.

web     IN      A       192.168.0.4
www     IN      CNAME   web
```

### /etc/bind/lab/rev.externa

```
$TTL    604800
@       IN      SOA     dns1.lab.lan. alexandre.lab.lan. (
                              1         ; Serial
                         604800         ; Refresh
                          86400         ; Retry
                        2419200         ; Expire
                         604800 )       ; Negative Cache TTL
;
@       IN      NS      lab.lan.
@       IN      NS      dns1.lab.lan.
@       IN      NS      dns2.lab.lan.
ns1     IN      A       192.168.0.2
ns2     IN      A       192.168.0.3
2       IN      PTR     dns1.lab.lan.
3       IN      PTR     dns2.lab.lan.
4       IN      PTR     web.lab.lan.
```

### Comandos úteis

```
netplan try
netplan apply
resolvectl

systemctl restart bind9
journalctl -xeu named.service
named-checkzone lab.interna rev.interna
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
        addresses: [8.8.8.8]                              
        search: []           
      routes:                
      - to: default          
        via: 192.168.100.1   
  version: 2
```

## Web

### /etc/netplan/network.yaml
```
network:
  ethernets:
    enp0s3:
      addresses:
      - 192.168.100.4/24
      nameservers:
        addresses: [8.8.8.8]
        search: []
      routes:
      - to: default
        via: 192.168.100.1
  version: 2
```
