#!/bin/bash

# Configuration
COMPOSE_FILE="docker-compose.yml"
BACKUP_SCRIPT="./scripts/backup.sh"

# Function to check if command was successful
check_status() {
    if [ $? -ne 0 ]; then
        echo "Error: $1"
        exit 1
    fi
}

# Create upgrade log
exec 1> >(tee -a upgrade_$(date +%Y%m%d_%H%M%S).log) 2>&1

echo "Starting n8n upgrade process..."

# Run backup first
echo "Running backup..."
bash "${BACKUP_SCRIPT}"
check_status "Backup failed"

# Pull new images
echo "Pulling new images..."
docker compose pull
check_status "Failed to pull new images"

# Stop services
echo "Stopping services..."
docker compose down
check_status "Failed to stop services"

# Start services
echo "Starting services with new images..."
docker compose up -d
check_status "Failed to start services"

# Wait for health checks
echo "Waiting for services to be healthy..."
sleep 30

# Check service health
docker compose ps | grep -q "unhealthy"
if [ $? -eq 0 ]; then
    echo "Warning: Some services are unhealthy!"
    docker compose ps
    exit 1
fi

echo "Upgrade completed successfully!" 