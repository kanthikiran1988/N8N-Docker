#!/bin/bash

# Check if running as root
if [ "$EUID" -ne 0 ]; then 
    echo "Please run as root"
    exit 1
fi

# Create n8n directory
N8N_DIR="/etc/n8n"
mkdir -p ${N8N_DIR}
mkdir -p ${N8N_DIR}/traefik
mkdir -p ${N8N_DIR}/backup
mkdir -p ${N8N_DIR}/scripts

# Copy configuration files
cp .env ${N8N_DIR}/.env
cp docker-compose.yml ${N8N_DIR}/
cp scripts/*.sh ${N8N_DIR}/scripts/

# Set up scripts in /usr/local/bin
cp ${N8N_DIR}/scripts/*.sh /usr/local/bin/
chmod +x /usr/local/bin/n8n-*

# Install systemd service
cp scripts/n8n-monitor.service /etc/systemd/system/
systemctl daemon-reload
systemctl enable n8n-monitor
systemctl start n8n-monitor

# Set up automatic backups with cron
(crontab -l 2>/dev/null; echo "0 2 * * * /usr/local/bin/n8n-backup.sh") | crontab -

# Set proper permissions
chown -R root:root ${N8N_DIR}
chmod 600 ${N8N_DIR}/.env

# Start the stack
cd ${N8N_DIR}
docker compose up -d

echo "Installation completed successfully!"
echo "Please check the logs with: docker compose logs -f" 