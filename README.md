# Serviços de Redes

## Como clonar?

```
git clone https://github.com/apgifro/redes-confs
```

## Comandos úteis na hora de testar

```
resolvectl
journalctl -xeu named.service
named-checkzone lab.interna rev.interna
nslookup lab.lan
ping lab.lan
```


## 2023-05-15


#### Configurar Apache


1. `/etc/apache2/apache2.conf`
    ``` 
     <Directory /srv/>
        Options Indexes FollowSymLinks AllowOverride None
        Require all granted
    </Directory>
    ```

2. `/etc/apache/sites-avaliable/000-default.conf` -> Configurações abaixo vem daí, lembre de ver e 
alterar o diretório.


3. `/etc/apache/sites-avaliable/web.conf`

    ```
    <VirtualHost www.laboratorio.lan:80>
        ServerAdmin webmaster@laboratorio.lan
        ServerName laboratorio.lan
        ServerAlias www.laboratorio.lan
        DocumentRoot /srv/laboratorio/public_html
        ErrorLog ${APACHE_LOG_DIR}/error.log
        CustomLog ${APACHE_LOG_DIR}/access.log combined
    </VirtualHost>
    ```

4. `a2ensite web.conf`


5. `systemctl reload apache2`


6. `mkdir -p srv/laboratorio/public_html`


#### Configurar SSL


7. `a2enmod ssl`


8. `a2enmod rewrite`


9. `mkdir /etc/apache2/ssl`


10. `openssl genrsa -out /etc/apache2/ssl/web.key
2048`


11. `openssl req -new -key /etc/apache2/ssl/web.key - out /etc/apache2/ssl/web.csr`


12. `openssl x509 -req /etc/apache2/ssl/web.csr /etc/apache2/ssl/web.key /etc/apache2/ssl/web.crt
-days 365 -in -signkey -out`


13. `chmod 600 web.csr`


14. `chmod 600 web.key`


15. `web2.conf`

```
<VirtualHost *:443>
   ServerName www.laboratorio.lan:443
   ServerAdmin suporte@laboratorio.lan
   DocumentRoot /srv/laboratorio/public_html
   ErrorLog /var/log/apache2/web-error.log
   CustomLog /var/log/apache2/ok-web-ssl.log
   SSLEngine on
   SSLCertificateFile /etc/apache2/ssl/web.crt
   SSLCertificateKeyFile /etc/apache2/ssl/web.key
</VirtualHost>

<VirtualHost *:80>
   RewriteEngine on
   ServerName web.laboratorio.lan
   Options FollowSymLinks
   RewriteCond %{SERVER_PORT} 80
   RewriteRule ^(.*) https://www.laboratorio.lan/ [R,L]
</VirtualHost>
```

16. `a2ensite web.conf`


17. `systemctl restart apache2`

## 2023-05-22

1. `sudo apt update`


2. `sudo apt install proftpd`



3. `/etc/proftpd/proftpd.conf`

```
ServerName  "Server_Aula"
DefaultRoot ~
```



4. `sudo systemctl restart proftpd`



5. `ftp web.laboratorio.lan`



6. Filezilla



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



7. Na máquina cliente, montar:



8. Criar `/srv/alunos/vendas`



- `sudo mount 192.168.100.2:/srv/vendas/Documentos vendas`



9. `sudo chown aluno.aluno vendas/`



10. `cd vendas/`



11. `mkdir teste`



- Deve aparecer sincronizado nos dois



12. Adicionar no `/etc/fstab`

```
192.168.100.2:/srv/vendas/Documentos	/srv/aluno/vendas	nfs	defaults	0 0
```











