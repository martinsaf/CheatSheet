
## 7. Application
---
- Nome: HTTP / HiperText Transfer Protocol
- Funcao: Transferencia de paginas web entre browser e servidor
- Porta: 80
- Uso tipico: Aceder websites
- Ferramenta: Browser, Wireshark para analisar requisicoes
- Lab: Capturar requisicoes HTTP para um site com Wireshark e identificar metodo GET

- [!bug] Problemas comuns:
	- Falha de resolucao -> testar com `nslookup google.com`
	- Latencia alta -> verificar cache DNS local
	- Servidor nao responde -> testar conectividade com `ping` ou `traceout`
---
- Nome: HTTPS / HTTP Secure
- Funcao: Transferencia segura de paginas web
- Porta: 443
- Uso tipico: Aceder websites com criptografia
- Ferramenta: Browser, Wireshark
- Lab: Capturar trafego HTTPS e observar handshake TLS

- [!bug] Problemas comuns:
	- Certificado invalido ou expirado -> verficar data/hora do sistema
	- Erro de handshake TLS -> inspecionar cipher suites com OpenSSL
	- Bloqueio por firewall -> testar com `curl -vk https://site`
---
- [!warning] Nome: FTP / File Transfer Protocol
- Funcao: Transferencia de arquivos entre cliente e servidor
- Porta: 21
- Uso tipico: Upload e download de arquivos 
- Ferramenta: FileZilla, Wireshark
- Lab: Transferir arquivo via FTP e capturar pacotes

- [!bug] Problemas comuns:
	- Porta 21 bloqueada -> testar com `testar servidor 21`
	- Modo ativo/passivo errado -> ajudar configuracao no cliente
	- Credenciais invalidas -> verificar utilizador e senha
---
- Nome: DNS / Domain Name System
- Funcao: Traducao de nomes de dominio em enderecos IP
- Porta: 53
- Uso tipico: Resolver nomes de sites para IP
- Ferramenta: nslookup, Wireshark
- Lab: Capturar uma consulta DNS e identificar o IP retornado

- [!bug] Problemas comuns:
	- Resolucao lenta -> trocar servidor DNS (ex. 8.8.8.8)
	- Falha de resposta -> verificar firewall/UDP 53
	- Cache desatualizada -> limpar cache com `ipconfig /flushdns`
---
- Nome: SMTP / Simple Mail Transfer Protocol
- Funcao: Envio de emails
- Porta: 25
- Uso tipico: Servidores de email enviando mensagens 
- Ferramenta: Thunderbird, Wireshark
- Lab: Capturar envio de email SMTP e observar comandos HELO, MAIL FROM

- [!bug] Problemas comuns:
	- Porta 25 bloqueada por ISP -> usar porta 587
	- Rejeicao de relay -> autenticar corretamente
	- Email marcado como SPAM -> verificar SPF/DKIM/DMARC
---
- Nome: POP3 / Post Office Protocol v3
- Funcao: Receber emails do servidor
- Porta: 110
- Uso tipico: Baixar emails de um servidor para o cliente
- Ferramenta: Outlook, Wireshark
- Lab: Capturar conexao POP3 e analisar autenticacao e recebimento de emails

- [!bug] Problemas comuns:
	- Credenciais invalidas -> verificar utilizador/senha
	- Porta 110 bloqueada -> testar conectividade `telnet`
	- Mensagens duplicads -> cliente mal configurado (nao apagar apos baixar)
---
- Nome: IMAP / Internet Message Access Protocol
- Funcao: Acesso a emails no servidor mantendo-os sincronizados
- Porta: 143
- Uso tipico: Ler e organizar emails sem baixa-los permanentemente 
- Ferramenta: Thunderbird, Wireshark
- Lab: Capturar conexao IMAP e observar sincronizacao de pastas

- [!bug] Problemas comuns:
	- Conexao lenta -> excesso de mensagens no servidor
	- Porta bloqueada -> testar conectividade TCP 143
	- Sincronizacao falha -> verificar configuracao SSL/TLS
---
- Nome: DHCP / Dynamic Host Configuration Protocol
- Funcao: Atribuicao automatica de IP e configuracao de rede
- Porta: 67 (servidor) / 68 (cliente)
- Uso tipico: Configuracao automatica de IPs em redes
- Ferramenta: Wireshark
- Lab: Capturar a negociacao DHCP (DISCOVER, OFFER, REQUEST, ACK) 

- [!bug] Problemas comuns:
	- Sem lease de IP -> servidor DHCP offline
	- IP duplicado -> conflito de enderecos na rede
	- Cliente nao renova -> verificar tempo de lease
---
## 6. Presentation
---
- Nome: TLS / Transport Layer Security
- Funcao: Criptografia e autenticacao de dados
- Porta: 443 (quando usado com HTTPS)
- Uso tipico: Seguranca em navegacao web e emails
- Ferramenta: Wireshark, OpenSSL
- Lab: Capturar handshake TLS no Wireshark e observar troca de chaves

- [!bug] Problemas comuns:
	- Erro de handshake -> verificar certificados/ciphers
	- Certificado autoassinado -> nao confiado pelo cliente
	- Versao TLS incompativel -> ajustar configuracao (TLS1.2/1.3)
---
- [!warning] Nome: SSL / Secure Sockets Layer
- Funcao: Antecessor do TLS, criptografia de dados em transito
- Porta: 443 (desatualizado, mas ainda visto em alguns sistemas)
- Uso tipico: Seguranca em sites antigos e alguns servicos legados
- Ferramenta: Wireshark
- Lab: Comparar sessao SSL com TLS em captura de pacotess

- [!bug] Problemas comuns:
	- Vulneravel a ataques (ex: POODLE)
	- Nao suportado em navegadores modernos
---
- Nome: MIME / Multipurpose Internet Mail Extensions
- Funcao: Codificacao de emails com anexos (texto, imagem, audio)
- Porta: Sem porta especifica (usado sobre SMTP, POP3, IMAP)
- Uso tipico: Enviar emails com anexos ou HTML
- Ferramenta: Wireshark, clientes de email
- Lab: Enviar email com anexo e analisar cabecalhos MIME

- [!bug] Problemas comuns:
	- Arquivo corrompido -> codificacao base64 incorreta
	- Cliente nao suporta -> anexos ilegiveis
---
- Nome: 
- Funcao: 
- Porta: 
- Uso tipico: 
- Ferramenta:
- Lab: 
---
## 5. Session
---
- Nome: RPC / Remote Procedure Call
- Funcao:  Permite execucao de funcoes em computadores remotos
- Porta: 135 (MS RPC)
- Uso tipico: Comunicacao entre sistemas distribuidos
- Ferramenta: Wireshark
- Lab: Observar chamadas RPC entre cliente e servidor em captura

- [!bug] Problemas comuns:
	- Porta 135 bloqueada -> falha de conexao RPC
	- Exploracao de vulnerabilidade (ex. MS Blaster)
---
- Nome: NetBIOS / Network Basic Input Output System
- Funcao: Gerencia sessoes de comunicacao entre computadores Windows
- Porta: 137-139
- Uso tipico: Compartilhamento de arquivos/impressoras em LANs antigas
- Ferramenta: Wireshark, nbstat
- Lab: Capturar trafego NetBIOS em uma rede Windows e analisar nomes de sessao

- [!bug] Problemas comuns:
	- Rede lenta -> broadcast excessivo
	- Seguranca fraca -> suscetivel a sniffing
---
- Nome: SMB / Server Message Block
- Funcao: Compartilhamento de arquivos, impressoras e comunicacao em rede
- Porta: 445 (SMB direto sobre TCP) / 137/139 (sobre NetBIOS) 
- Uso tipico: Compartilhar pastas e impressoras em redes Windows
- Ferramenta: Wireshark, smbcliente
- Lab: Conectar a um recurso compartilhado via SMB e capturar autenticacao NTLM

- [!bug] Problemas comuns:
	- Vulnerabilidades conhecidas (ex. EthernalBlue)
	- Lentidao no acesso -> latencia de rede alta
---
- Nome: PPTP / Point-to-Point Tunneling Protocol
- Funcao: Criacao de tuneis VPN em redes IP
- Porta: TCP 1723
- Uso tipico: VPNs classicas (substituidas por L2TP, OpenVPN, IPSec)
- Ferramenta: Wireshark, cliente VPN
- Lab: Configurar uma conexao PPTP e capturar pacotes GRE encapsulados

- [!bug] Problemas comuns:
	- Criptografia fraca -> inseguro atualmente
	- Bloqueio de porta TCP 1723
---
- Nome: Kerberos 
- Funcao: 
- Porta: 88
- Uso tipico: 
- Ferramenta:
- Lab: 
---
- Nome: LDAP
- Funcao: 
- Porta: 389
- Uso tipico: 
- Ferramenta:
- Lab: 
---
- Nome: 
- Funcao: 
- Porta: 
- Uso tipico: 
- Ferramenta:
- Lab: 
---
## 4. Transport
---
- Nome: TCP / Transmission Control Protocol
- Funcao: Comunicacao confiavel, com controlo de fluxo e ordem
- Porta: Varias (HTTP 80, HTTPS 443, etc)
- Uso tipico: Navegacao web, email, transferencia de arquivos
- Ferramenta: Wireshark, netstat
- Lab: Capturar trafego TCP e identificar handshake 3-way (SYN, SYN-ACK, ACK)

- [!bug] Problemas comuns:
	- Conexoes lentas -> verificar janela TCP e retransmissoes
	- Conexao nao estabelecida -> checar firewall ou porta bloqueada
	- Reset de conexao (RST) -> servidor recusou ou fechou a sessao abruptamente
---
- Nome: UDP / User Datagram Protocol
- Funcao: Comunicacao rapida, sem confirmacao de entrega
- Porta: DNS 53, DHCP 67/68, VoIP, jogos online
- Uso tipico: Streaming de video, chamadas VoIP, jogos em tempo real
- Ferramenta: Wireshark
- Lab: Capturar trafego UDP de uma consulta DNS e observar ausencia de handshake

- [!bug] Problemas comuns:
	- Perda de pacotes -> impacto direto em streaming/voz
	- Porta bloqueada -> falha na resolucao DNS ou no servico
	- Latencia alta -> eco perceptivel em chamadas VoIP
---
- Nome: SCTP / Stream Control Transmisson Protocol
- Funcao: 
- Porta: 
- Uso tipico: 
- Ferramenta:
- Lab: 
---

## 3. Network
---
- Nome: IP / Internet Protocol
- Funcao: Enderecamento logico e roteamento de pacotes
- Porta: Nao usa portas (nivel de rede)
- Uso tipico: Transporte de pacotes entre redes diferentes
- Ferramenta: ipconfig, ping, Wireshark
- Lab: Observar cabecalhos IP em captura de pacotes

- [!bug] Problemas comuns:
	- Conflito de IP -> verificar tabela ARP e DHCP
	- Mascara de rede errada -> comunicacao limitada apenas dentro da LAN
	- Roteamento incorreto -> checar tabela de rotas (route print)
---
- Nome: ICMP / Internet Control Message Protocol
- Funcao: Diagnostico e mensagens de erro de rede
- Porta: Sem portas (usa diretamente IP)
- Uso tipico: Comando ping, traceroute
- Ferramenta: ping, traceroute, Wireshark
- Lab: Executar ping e capturar pacotes ICMP Echo Request e Echo Reply

- [!bug] Problemas comuns:
	- Echo bloqueado em firewall -> ping sem resposta
	- TTL excedido -> roteamento em loop
	- Destination Unreachable -> rede ou host inalcancavel
---
- Nome: IPSec / Internet Protocol Security
- Funcao: Seguranca para IP (criptografia e autenticacao)
- Porta: Protocolos 50 (ESP) e 51 (AH)
- Uso tipico: VPNs baseadas em IP
- Ferramenta: Wireshark, strongSwan
- Lab: Configurar VPN IPSec e capturar pacotes criptografados

- [!bug] Problemas comuns:
	- Falha na negociacao IKE -> checar configuracao de chaves/algoritmos
	- Pacotes descartados -> incompatibilidade de politicas entre peers
	- MTU excedida -> fragmentacao de pacotes IPsec
---
- Nome: OSPF / 
- Funcao: 
- Porta: 89
- Uso tipico: 
- Ferramenta:
- Lab: 
---
- Nome: BGP
- Funcao: 
- Porta: 179
- Uso tipico: 
- Ferramenta:
- Lab: 
---


## 2. Data Link
---
- Nome: Ethernet (IEEE 802.3)
- Funcao: Comunicacao em redes cabeadas (quadro de dados)
- Porta: Nao usa portas (camada de enlace)
- Uso tipico: LANs com cabos Ethernet
- Ferramenta: Wireshark, ifconfig
- Lab: Capturar trafego Ethernet e analisar enderecos MAC origem/destino

- [!bug] Problemas comuns:
	- Colisoes em hubs antigos -> perda de desempenho
	- Loop de rede sem STP -> broadcast storm
	- MAC flapping -> verificar multiplas conexoes indevidas
---
- Nome: Wi-Fi (IEEE 802.11) 
- Funcao:  Comunicacao sem fio em LANs
- Porta: Nao usa portas (camada de enlace)
- Uso tipico: Redes sem fio domesticas e corporativas
- Ferramenta: Wireshark em modo monitor
- Lab: Capturar pacotes 802.11 e observar beacons de APs

- [!bug] Problemas comuns:
	- Sinal fraco -> baixa velocidade e quedas
	- Interferencia (2.4GHz) -> canais sobrepostos
	- Autenticacao falha -> senha errada ou protocolo incompativel (WPA vs WPA2)
---
- Nome: ARP / Address Resolution Protocol
- Funcao: Mapeia enderecos IP para enderecos MAC
- Porta: Sem portas (protocol 0x0806)
- Uso tipico: Resolver endereco MAC do gateway antes de enviar pacotes IP
- Ferramenta: ARP, Wireshark
- Lab: Capturar trafego ARP e observar solicitacoes (Who has...?) e respostas

- [!bug] Problemas comuns:
	- ARP spoofing/poisoning -> redirecionamento malicioso
	- Cache ARP desatualizado -> falha de comunicacao local
	- Falta de resposta ARP -> host desconectado
---
- Nome: 
- Funcao: 
- Porta: 
- Uso tipico: 
- Ferramenta:
- Lab: 
---
## 1. Physical
---
- Nome: Ethernet (cabo par tracado, fibra optica)
- Funcao: Meio de transmissao de dados
- Porta: Nao se aplica (camada fisica)
- Uso tipico: Conectar PCs, switches, roteadores
- Ferramenta: Testador de cabos, Wireshark (camada superior)
- Lab: Montar cabo Ethernet e testar conectividade

- [!bug] Problemas comuns:
	- Cabo danificado -> perda total de link
	- Conector mal crimpado -> erros de transmissao
	- Comprimento excessivo (>100m em cobre) -> atenuacao
---
- Nome: Wireless (radio frequencia)
- Funcao: Transmissao de dados sem fio
- Porta: Nao se aplica
- Uso tipico: Wi-Fi, Bluetooth
- Ferramenta: Adaptador Wi-Fi em modo monitor
- Lab: Capturar pacotes 802.11 e observar sinal de beacon

- [!bug] Problemas comuns:
	- Distancia excessiva -> perda de sinal
	- Barreiras fisicas (paredes) -> interferencia
	- Saturacao do espectro -> desconexoes frequentes
---
- Nome: Optico (fibra optica)
- Funcao: Transmissao de dados por pulso de luz
- Porta: Nao se aplica
- Uso tipico: Backbones de internet, redes de alta velocidade
- Ferramenta: OTDR (Optical Time Domain Reflectometer)
- Lab: Medir atenuacao em fibra optica durante um teste pratico

- [!bug] Problemas comuns:
	- Dobra excesiva da fibra -> perda de potencia
	- Conector sujo/mal polido -> atenuacao alta
	- Fibra partida -> perda total do sinal
---


