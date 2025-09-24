## Sistema & Info
- `cat /etc/os-release` -> Ver versão do SO
- `<comando> | ccze -A` -> Ver info detalhada do sistema
- `uname -a` -> Ver kernel
- `apt update && apt upgrade`
- `netsh interface ip set address name="Ethernet" static 192.168.100.1 255.255.255.0` -> segunda interface
## Journalctl (Logs do Systemd)
- Ver todos os logs (desde o  boot): `journalctl`
- Ver logs de um serviço especifico: `journalctl -u nome_do_serivo.service` (ex: `-u ssh.service`)
- Ver logs por prioridade:
	- `journalctl -p err..alert` -> So erros e acima
	- `journalctl -p err` -> So erros
	- Níveis: `emrg` (0), `alert` (1), `crit` (2), `err` (3), `warning` (4), `notice` (5), `info` (6), `debug` (7)
- Ver logs desde/ate
	- `journalctl --since "2024-01-15 14:30:00"`
	- `journalctl --since "1 hour ago"`
	- `journalctl --since yesterday --until "today 09:00"`
- Seguir logs em tempo real (like `tail -f`): `journalctl -f`
- Ver logs do ultimo boot: `journalctl -b`
- Ver logs de um binario/executavel: `journalctl /usr/bin/sshd`
- Formatar a saida:
	- `journalctl -o json-pretty` -> Para JSON legivel (util para scripts)
	- `journalctl -o verbose` -> Mostra todos os campos disponiveis
- Combina filtros (ex: erros do SSH desde ontem):
	- `journalctl -u ssh.service -p err --since yesterday`
- Protegendo os logs:
	- Ver uso em disco: `journalctl --disk-usage`
	- Limpar logs antigos (>2 semanas): `sudo journalctl --cavum-time=2weeks`
## Navegação

- Comandos: `cd`, `ls`, `pwd`, `mkdir`, `rm`
- Função: Navegar, listar e gerir ficheiros/diretórios
- Problemas comuns:
    - Erro “Permission denied” → usar `sudo` ou verificar permissões
    - Comando não encontrado → verificar path ou instalar utilitário

---

## Gestão de utilizadores e grupos

- Comandos: `adduser`, `deluser`, `usermod`, `addgroup`, `chfn`, `sudo visudo`
- Função: Criar, remover e modificar utilizadores/grupos; gerenciar permissões de `sudo`
- Problemas comuns:
    - Utilizador não consegue `sudo` → verificar `/etc/sudoers`
    - Grupo não existe → criar grupo primeiro com `addgroup`
    - Criação do utilizador interrompida -> `chfn <user>` (change finger)
    - [!⚠] Não editar `/etc/sudoers` **diretamente**, sempre usar `sudo visudo` para evitar corromper o arquivo

##### Gestão de utilizadores
- Criar utilizador -> `sudo adduser nome`
- Apagar utilizador -> `sudo deluser nome`
- Modificar utilizador -> `sudo usermod [opcoes] nome`
- Alterar palavra-chave -> `passwd nome`
- Trocar de utilizador -> `su - nome`
- Ver grupo primário e UID -> `id nome`
- Ver entrada completa no passwd -> `grep nome /etc/passwd`
##### Gestão de grupos
- Criar grupo -> `sudo addgroup grupo`
- Adicionar user a grupo -> `sudo usermod -aG grupo nome`
- Ver grupos do user -> `groups nome`

##### Permissões de ficheiros e pastas
- Ver permissões -> `ls -l`
- Alterar permissões -> `chmod [valor] ficheiro`
- Alterar dono -> `chown user:group ficheiro`
- Alterar propriedade de ficheiro para o grupo -> `chown :grupo ficheiro`
- Alterar grupo -> `chgrp grupo ficheiro`

##### 📌Tabela de permissões `chmod` (octal)
| Valor | Permissões | Significado                  |
| ----- | ---------- | ---------------------------- |
| 0     | ---        | Nenhuma permissão            |
| 1     | --x        | So execução                  |
| 2     | -w-        | So escrita                   |
| 3     | -wx        | Escrita + execução           |
| 4     | r--        | so leitura                   |
| 5     | r-x        | Leitura + execução           |
| 6     | rw-        | Leitura + escrita            |
| 7     | rwx        | Leitura + escrita + execução |

- So o owner pode ler e escrever -> `chmod 600 ~/caminho_do_ficheiro`
##### `sudo` & privilégios
- Editar `sudoers` -> `sudo visudo`
- Dar permissão `sudo` a um user -> adicionar linha no `sudoers`:
```EBNF
user ALL=(ALL) ALL
```
- Restringir comandos específicos:
```EBNF
tecnico ALL=(ALL) /usr/bin/systemctl restart ssh
```

##### Segurança SSH e acesso
- Config SSH -> `/etc/ssh/ssh_config`
	- `AllowUsers analyst tecnico` -> so permite logins a users específicos
	- `DenyUsers operador` -> bloqueia este user
- Reiniciar SSH -> `sudo systemctl restart ssh`

```bash
#!/bin/bash
# Verifica falhas de login SSH nas ultimas 2 horas
count=$(journalctl -u ssh.service --since "2 hours ago" | grep "Failed password" | wc -l)
if [ $count -gt 5 ]; then
	echo "[ALERTA] $count falhas de login SSH nas utlimas 2h!" | wall
	# Poderia tambem enviar um email aqui
fi
```
- Agendar este script com cron para correr de 10 em 10 minutos.

---

## Gestão de processos

- Comandos: `ps`, `top`, `ps -u <user>`, `kill`
- Função: Ver processos em execução (todos ou de um utilizador) e terminá-los
- Problemas comuns:
    - “Operation not permitted” → usar `sudo`
    - PID incorreto → confirmar PID com `ps` novamente        

##### Terminar um processo
```bash
kill <PID>
```
###### Se o processo resistir
```bash
kill -9 <PID>
```

---

## Gestão de serviços

- Comandos modernos: `systemctl start/stop/restart/status <servicos>`
- Extra: `systemctl list-units --type=service` (listar serviços ativos)
- Legado: `service <name> start/stop/restart/status` (compatibilidade)
- Função: Controlar serviços do sistema (`SSH`, `cron`, `rsyslog`, networking)
- Problemas comuns:
    - Serviço não inicia → verificar logs em `/var/log/`
    - Porta já em uso → identificar processo com `lsof -i :80`
    - Apenas admin com `sudo` consegue controlar serviços

##### Ver serviços ativos
```bash
systemctl liust-units --type=service
```

##### Controlar serviços
```bash
sudo systemctl start ssh
sudo systemctl stop ssh
sudo systemctl restart ssh
sudo systemctl status ssh
sudo systemctl suspend # suspender o sistema
sudo systemctl hibernate # hibernar o sistema
```

- Depois de `systemctl restart ssh`, verificar se correu bem: `journalctl -u ssh.service --since "2 minutes ago" -n 20`
- Se um serviço falhar ao iniciar, os logs são o primeiro sitio para ver: `journalctl -u nome_do_servico_falhado.service -p err`

---

## Scripts simples

- Função: Automatizar tarefas como backup diário ou logs
- Exemplo: Script de backup diário ou log 
- Ferramenta: `bash`, editor `nano`/`vim`
- Problemas comuns:
    - Permissões de execução → `chmod +x script.sh`
    - Caminhos errados → usar paths absolutos
---
## Rede
- Comandos: `ping`, `ipconfig`, `ip a`, `netstat`, `curl`, `wget`
- Função: Testar conectividade e informações de rede
- Problemas comuns:
	- Host inacessível -> checar cabo, Wi-Fi ou firewall
	- Comando não encontrado -> instalar pacote correspondente (net-tools) para `ifconfig`
	- Resposta lenta -> verificar latência e rota


```bash
# Listar logs da diretoria /var//log do mais recente para o mais antigo
ls -lt /var/log
```

```bash
# Mostra erros de login
sudo tail -n 20 /var/log/syslog | ccze -A # linhas com falhas de autenticacao coloridas
```




---

## Pacotes / Gestão de software
- Comandos: `apt update`, `apt upgrade`, `apt install`, `apt remove`, `dpkg -i`
- Função: Instalar, atualizar ou remover pacotes em distribuições Debian/Ubuntu
- Problemas comuns:
	- "Package not found" -> atualizar repositórios com `apt update`
	- Dependências quebradas -> usar `apt --fix-broken install`
	- Permissão negada -> usar `sudo`
---

## Permissões e propriedades de ficheiros
- Comandos: `chmod`, `chown`, `chgrp`, `ls -l`
- Função: Alterar permissões e propriedades de arquivos e diretorias
- Problemas comuns:
	- "Operation not permitted" -> usar sudo
	- Permissões incorretas -> rever números/flags de `chmod`
	- Utilizador/grupo inexistente -> verificar com id ou groups
---

## Discos e armazenamento
- Comandos: `df`, `du`, `mount`, `umount`, `lsblk`
- Função: Verificar uso de disco e gerenciar pontos de montagem
- Problemas comuns:
	- Montagem falhou -> verificar se a diretoria existe ou se esta' ocupada
	- Permissão negada -> usar `sudo`
	- Espaço insuficiente -> libertar ou expandir partição
---

## Compressão e arquivos
- Comandos: `tar`, `gzip`, `gunzip`, `zip`, `unzip`
- Função: Compactar e descompactar arquivos e diretorias
- Problemas comuns:
	- Arquivo inexistente -> conferir path e nome do arquivo
	- Permissão negada -> usar `sudo`
	- Formato invalido -> verificar extensão correta

---
## Firewall
- Comandos: `ufw`
