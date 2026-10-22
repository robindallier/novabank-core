#!/usr/bin/env bash
set -euo pipefail

if [ "$EUID" -ne 0 ]; then
    echo "[-] Erreur : Lancez ce script en root ou avec sudo."
    exit 1
fi

echo "[+] 1. Mise à jour et installation de PostgreSQL et UFW..."
apt update
apt install -y postgresql postgresql-client ufw

echo "[+] 2. Configuration du pare-feu UFW..."
ufw default deny incoming
ufw default allow outgoing
ufw allow from 192.168.56.0/24 to any port 5432 proto tcp
ufw allow 22/tcp
ufw --force enable

echo "[+] 3. Configuration des réglages PostgreSQL..."
CONF_DIR="/etc/postgresql/18/main/conf.d"
mkdir -p "$CONF_DIR"

cat << 'SETTINGS' > "$CONF_DIR/novabank.conf"
listen_addresses = '*'
password_encryption = 'scram-sha-256'
log_connections = on
log_statement = 'all'
SETTINGS

systemctl restart postgresql
echo "[+] Étape E1 : Installation et configuration terminées !"
