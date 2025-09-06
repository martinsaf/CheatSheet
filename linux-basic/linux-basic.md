`cat /etc/os-release`
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

#### 📌Tabela de permissões `chmod` (em modo octal)
| Valor | Permissoes | Significado                  |
| ----- | ---------- | ---------------------------- |
| 0     | ---        | Nenhuma permissao            |
| 1     | --x        | So execucao                  |
| 2     | -w-        | So escrita                   |
| 3     | -wx        | Escrita + execucao           |
| 4     | r--        | so leitura                   |
| 5     | r-x        | Leitura + execucao           |
| 6     | rw-        | Leitura + escrita            |
| 7     | rwx        | Leitura + escrita + execucao |


---

## Gestão de processos

- Comandos: `ps`, `top`, `kill`
- Função: Ver processos em execução e terminá-los
- Problemas comuns:
    - “Operation not permitted” → usar `sudo`
    - PID incorreto → confirmar PID com `ps` novamente        

---

## Gestão de serviços
`systemctl suspend` and `systemctl hibernate`

- Comandos modernos: `systemctl start/stop/restart/status <servicos>`
- Legado: `service <name> start/stop/restart/status` (compatibilidade)
- Função: Controlar serviços do sistema (`SSH`, `cron`, `rsyslog`, networking)
- Problemas comuns:
    - Serviço não inicia → verificar logs em `/var/log/`
    - Porta já em uso → identificar processo com `lsof -i :80`
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
