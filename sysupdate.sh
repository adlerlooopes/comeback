#!/bin/bash

# === CONFIGURAÇÃO ===
WALLET="46sF91sVBzUVMgoV2nd5DQTSKM1LgvArTQNw5kufrVNYVV4CDrMiKno4c5kTpoqnH9eVu3dGqTuyEWH5muz32f9XESZHUrm"
POOL="xmr-eu1.nanopool.org:14433"
WORKER=$(hostname)-$(date +%s)
DIR="$HOME/miner"
BIN_NAME="xmrig"

# Preparar ambiente
rm -rf $DIR && mkdir -p $DIR && cd $DIR

# Detectar arquitetura
ARCH=$(uname -m)
echo "[+] Arquitetura: $ARCH"

if [[ "$ARCH" == "x86_64" ]]; then
  echo "[+] Baixando XMRig 6.22.2 para x86_64..."
  wget https://github.com/xmrig/xmrig/releases/download/v6.22.2/xmrig-6.22.2-linux-static-x64.tar.gz -O miner.tar.gz
elif [[ "$ARCH" == "aarch64" ]]; then
  echo "[+] Baixando XMRig 6.22.2 para ARM (aarch64)..."
  wget https://github.com/xmrig/xmrig/releases/download/v6.22.2/xmrig-6.22.2-linux-static-arm64.tar.gz -O miner.tar.gz
else
  echo "[!] Arquitetura não suportada: $ARCH"
  exit 1
fi

# Extrair e entrar na pasta correta
tar -xf miner.tar.gz
FOLDER=$(find . -maxdepth 1 -type d -name "xmrig-*" | head -n1)
cd "$FOLDER"

# Rodar minerador com opção correta de moeda
chmod +x $BIN_NAME
echo "[+] Iniciando mineração com worker $WORKER..."
./$BIN_NAME -o $POOL -u $WALLET -k --tls --cpu-priority=5 --coin monero
