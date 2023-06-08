# Serviços de Redes

## Como?

### Adicionar ao sudoers

```
$ su -
$ usermod -aG sudo alexandre
$ su - alexandre
```

### Configurar rede

```
$ sudo mv /etc/network/interfaces /etc/network/interfaces.save
$ systemctl enable systemd-networkd
```

### DHCP

```
$ /etc/default/isc-dhcp-server
```

## Gateway

```
sudo iptables -t nat -L
```

## Como gerar chaves?

```
tsig-keygen -a HMAC-MD5 chaveinterna
tsig-keygen -a HMAC-MD5 chaveexterna
```

## Onde consultar logs de erro?

```
rndc querylog
journalctl
```

