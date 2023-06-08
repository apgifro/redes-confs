# Serviços de Redes

![Moodle](/readme/images/moodle.png)

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



## 2023-05-29

```
iptables -A FORWARD -p udp -s $HOST -d $DNS1 --dport 53 -j ACCEPT
iptables -A FORWARD -p tcp -s $DNS1 -d $HOST --sport 53 -j ACCEPT
iptables -t nat -A PREROUTING -p udp -s $HOST -d 192.168.56.2 --dport 53 -j DNAT --to $DNS1:53


dentro do gateway
iptables -A FORWARD -p udp -s $HOST -d $DNS1 --dport 53 -j ACCEPT
iptables -A FORWARD -p tcp -s $DNS1 -d $HOST --sport 53 -j ACCEPT
iptables -t nat -A PREROUTING -p udp -s $HOST -d $IP2 --dport 53 -j DNAT --to $DNS1:53
```


1. `sudo apt install nfs-kernel-server -y`



2. `sudo apt install nfs-common -y`



3. sudo vim /etc/exports

```
/srv/vendas/Documentos  192.168.100.0/24(rw,no_root_squash,sync)
```

4. Criar `/srv/vendas/Documentos`



5. `sudo chmod 756 -R vendas/`



6. `systemctl restart nfs-kernel-server`



- Na máquina cliente, montar:



8. Criar `/srv/alunos/vendas`



9. `sudo mount 192.168.100.2:/srv/vendas/Documentos vendas`



10. `sudo chown aluno.aluno vendas/`



11. `cd vendas/`



12. `mkdir teste`



- Deve aparecer sincronizado nos dois



13. Adicionar no `/etc/fstab`

```
192.168.100.2:/srv/vendas/Documentos	/srv/aluno/vendas	nfs	defaults	0 0
```











