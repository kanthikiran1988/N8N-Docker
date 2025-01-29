#!/bin/bash

# Create required directories
mkdir -p traefik
mkdir -p backup
mkdir -p scripts

# Copy scripts and set permissions
cp scripts/*.sh /usr/local/bin/
chmod +x /usr/local/bin/n8n-*

# Install systemd service
cp scripts/n8n-monitor.service /etc/systemd/system/
systemctl daemon-reload
systemctl enable n8n-monitor
systemctl start n8n-monitor

# Set up automatic backups with cron
(crontab -l 2>/dev/null; echo "0 2 * * * /usr/local/bin/n8n-backup.sh") | crontab -

# Start the stack
docker compose up -d 