# Serviços de Redes

## Como usar?

- Crie as máquinas no VirtualBox
- Clone o repositório em cada uma delas
- Acesse cada pasta correspondente a máquina
- Altere os IPs para o seu nos arquivos de configurações
- Execute o script `setup.sh`
- Se nenhum erro ocorrer, depois teste e tudo pronto!
- Boa sorte!


## Como clonar?

```
git clone https://github.com/apgifro/redes-confs
```

## Comandos úteis na hora de testar

```
resolvectl
journalctl -xeu named.service
named-checkzone lab.interna rev.interna
ping lab.lan
```
