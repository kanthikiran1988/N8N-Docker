# N8N Enterprise Production Setup

This repository contains a production-ready setup for N8N workflow automation platform with automatic SSL, monitoring, and backup solutions.

## Features

- 🔒 Automatic SSL certificate management with Let's Encrypt
- 📊 Monitoring system with Slack/Discord notifications
- 💾 Automated backup system
- 🔄 Safe upgrade process
- 🚀 Production-grade Docker setup
- 📦 PostgreSQL database for data persistence
- 🗄️ Redis for queue management
- 🔍 Health checks for all services

## Prerequisites

- Docker and Docker Compose v2
- Linux server (recommended Ubuntu 20.04 or later)
- Domain name pointed to your server
- Root or sudo access

## Directory Structure 
```
.
├── scripts/
│   ├── backup.sh
│   ├── install.sh
│   ├── monitor.sh
│   ├── upgrade.sh
│   └── n8n-monitor.service
├── traefik/
│   └── (dynamic config - created automatically)
├── ssl/
│   └── (certificates - created automatically)
├── .env.example
├── docker-compose.yml
└── README.md
```

## Installation

1. Clone this repository:
```bash
git clone https://github.com/yourusername/n8n-production
cd n8n-production
```

2. Copy the example environment file and modify it:
```bash
cp .env.example .env
nano .env
```

3. Update the following variables in `.env`:
- `DOMAIN`: Your domain name
- `SSL_EMAIL`: Your email for Let's Encrypt
- `N8N_HOST`: Your n8n subdomain
- All passwords and sensitive data

4. Run the installation script:
```bash
chmod +x scripts/install.sh
sudo ./scripts/install.sh
```

## Backup System

Backups are automatically scheduled to run daily at 2 AM. They include:
- PostgreSQL database dump
- N8N data volume backup
- Optional remote storage sync (requires rclone setup)

To manually trigger a backup:
```bash
sudo /usr/local/bin/n8n-backup.sh
```

## Monitoring

The monitoring system checks:
- Container health status
- Disk usage
- Service availability

Alerts are sent to:
- Slack (if configured)
- Discord (if configured)

To configure notifications:
1. Update the webhook URLs in `.env`
2. Restart the monitoring service:
```bash
sudo systemctl restart n8n-monitor
```

## Upgrading

To safely upgrade N8N and all services:
```bash
sudo /usr/local/bin/n8n-upgrade.sh
```

The upgrade process:
1. Creates a backup
2. Pulls new images
3. Performs a rolling update
4. Verifies health status

## Security Considerations

1. Change all default passwords in `.env`
2. Use strong passwords
3. Keep the encryption key safe
4. Regularly update all services
5. Monitor system logs
6. Set up a firewall

## Maintenance

### Viewing Logs
```bash
# All services
docker compose logs -f

# Specific service
docker compose logs -f n8n
```

### Checking Status
```bash
# View all container statuses
docker compose ps

# Check monitoring service
sudo systemctl status n8n-monitor
```

### Managing Services
```bash
# Stop all services
docker compose down

# Start all services
docker compose up -d

# Restart specific service
docker compose restart n8n
```

### Database Management
```bash
# Access PostgreSQL CLI
docker compose exec postgres psql -U n8n -d n8n

# Create manual backup
sudo /usr/local/bin/n8n-backup.sh
```

## Troubleshooting

### Common Issues

1. SSL Certificate Issues
```bash
# Check Traefik logs
docker compose logs traefik
```

2. Database Connection Issues
```bash
# Check PostgreSQL logs
docker compose logs postgres
```

3. N8N Not Starting
```bash
# Check N8N logs
docker compose logs n8n
```

### Health Check Failed
If health checks are failing:
1. Check the logs of the failing service
2. Verify all environment variables are set correctly
3. Ensure all required ports are available
4. Check system resources (CPU, Memory, Disk)

## Performance Tuning

### Redis Configuration
- Adjust memory settings in docker-compose.yml
- Monitor Redis memory usage
- Configure proper maxmemory-policy

### PostgreSQL Optimization
- Adjust shared_buffers
- Configure work_mem
- Set effective_cache_size

### System Requirements

Minimum recommended specifications:
- CPU: 2 cores
- RAM: 4GB
- Storage: 20GB

Production recommended specifications:
- CPU: 4 cores
- RAM: 8GB
- Storage: 50GB or more

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Support

If you encounter any issues or need support:
1. Check the [Troubleshooting](#troubleshooting) section
2. Open an issue in this repository
3. Check [N8N documentation](https://docs.n8n.io/)
4. Join [N8N community](https://community.n8n.io/)

## Acknowledgments

- [N8N](https://n8n.io/) - The awesome workflow automation tool
- [Traefik](https://traefik.io/) - The cloud native application proxy
- [Docker](https://www.docker.com/) - Container platform
- All contributors to this project

## Author

Your Name - [@yourgithubhandle](https://github.com/yourgithubhandle)

## Version History

- 1.0.0
  - Initial Release
  - Basic setup with SSL, monitoring, and backups