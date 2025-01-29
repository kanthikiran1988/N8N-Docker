#!/bin/bash

# Configuration
BACKUP_DIR="/backup"
POSTGRES_CONTAINER="n8n-postgres-1"
N8N_DATA_VOLUME="n8n_data"
RETENTION_DAYS=7
DATE=$(date +%Y%m%d_%H%M%S)

# Create backup directory if it doesn't exist
mkdir -p "${BACKUP_DIR}"

# Backup PostgreSQL database
echo "Backing up PostgreSQL database..."
docker exec ${POSTGRES_CONTAINER} pg_dump -U ${POSTGRES_USER} ${POSTGRES_DB} | gzip > "${BACKUP_DIR}/n8n_db_${DATE}.sql.gz"

# Backup n8n data volume
echo "Backing up n8n data..."
docker run --rm -v ${N8N_DATA_VOLUME}:/data -v ${BACKUP_DIR}:/backup alpine tar czf "/backup/n8n_data_${DATE}.tar.gz" -C /data .

# Upload to remote storage (example with rclone)
if command -v rclone &> /dev/null; then
    echo "Uploading backups to remote storage..."
    rclone copy "${BACKUP_DIR}" remote:n8n-backups/
fi

# Clean up old backups
echo "Cleaning up old backups..."
find "${BACKUP_DIR}" -type f -mtime +${RETENTION_DAYS} -delete

echo "Backup completed successfully!" 