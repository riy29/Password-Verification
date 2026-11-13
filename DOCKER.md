# Docker Deployment Guide

## Overview

The AD Password Manager is containerized using Docker with separate containers for:
- **Backend API** (Node.js + Express)
- **Frontend UI** (React + Nginx)
- **Database** (SQL Server)

## Prerequisites

- Docker Desktop installed and running
- Docker Compose (included with Docker Desktop)
- At least 4GB RAM allocated to Docker
- Ports 3000, 3001, 1433 available

## Quick Start - Production

### 1. Build and Start Containers

```bash
# Navigate to project root
cd PMP

# Build and start all containers
docker compose up -d

# View logs
docker compose logs -f
```

### 2. Verify Containers

```bash
# Check status
docker compose ps

# Expected output:
# NAME                           STATUS
# ad-password-manager-db         Up (healthy)
# ad-password-manager-api        Up (healthy)
# ad-password-manager-ui         Up (healthy)
```

### 3. Access the Application

- **Frontend**: http://localhost:3000
- **API**: http://localhost:3001/api
- **Health Check**: http://localhost:3001/api/health
- **Database**: localhost:1433 (SQL Server)

## Quick Start - Development

### 1. Start Development Containers

```bash
# Navigate to project root
cd PMP

# Start with development compose file
docker compose -f docker-compose.dev.yml up -d

# View logs with hot reload
docker compose -f docker-compose.dev.yml logs -f
```

### 2. Features

- **Hot Reload**: Changes to src/ automatically rebuild
- **Live Debug**: Access Node debugger on port 9229
- **React Fast Refresh**: Frontend updates in browser without refresh
- **Database Persistence**: Data persists in volumes

### 3. Access Development

- **Frontend**: http://localhost:3000
- **Backend**: http://localhost:3001/api
- **Database**: localhost:1433

## Configuration

### Environment Variables

Edit variables in `docker-compose.yml` or `docker-compose.dev.yml`:

```yaml
environment:
  # Active Directory
  AD_URL: ldap://your-ad-server.com
  AD_BASE_DN: dc=company,dc=com
  AD_ADMIN_USER: admin@company.com
  AD_ADMIN_PASSWORD: your_password
  
  # JWT
  JWT_SECRET: your-strong-secret-key
  
  # Email (SMTP)
  SMTP_HOST: smtp.gmail.com
  SMTP_USER: your-email@gmail.com
  SMTP_PASSWORD: your-app-password
  
  # SMS (Twilio)
  TWILIO_ACCOUNT_SID: your_sid
  TWILIO_AUTH_TOKEN: your_token
  TWILIO_PHONE_NUMBER: +1234567890
```

### Database Connection

SQL Server credentials in compose file:
- **Server**: `mssql:1433` (internal), `localhost:1433` (external)
- **Username**: `sa`
- **Password**: `P@ssw0rd123!`

**Change default password** by editing `docker-compose.yml`:

```yaml
mssql:
  environment:
    MSSQL_SA_PASSWORD: YourNewP@ssw0rd123!
```

## Container Management

### View Logs

```bash
# All services
docker compose logs -f

# Specific service
docker compose logs -f backend
docker compose logs -f frontend
docker compose logs -f mssql

# Last 100 lines
docker compose logs --tail=100
```

### Stop Containers

```bash
# Stop running containers (data persists)
docker compose stop

# Resume stopped containers
docker compose start

# Remove containers (data persists in volumes)
docker compose down

# Remove containers and volumes (DELETE DATA)
docker compose down -v
```

### Rebuild Containers

```bash
# Rebuild after code changes
docker compose build

# Rebuild specific service
docker compose build backend
docker compose build frontend

# Rebuild and restart
docker compose up -d --build
```

### Access Container Shell

```bash
# Backend shell
docker exec -it ad-password-manager-api sh

# Frontend shell
docker exec -it ad-password-manager-ui sh

# Database shell
docker exec -it ad-password-manager-db /bin/bash
```

### View Container Stats

```bash
# Real-time resource usage
docker stats

# Or per container
docker stats ad-password-manager-api
```

## Database Setup

### Initialize Database

The database schema is automatically initialized when the container starts using `database.sql`.

### Connect to Database

#### Using SQL Server Management Studio

```
Server: localhost,1433
Authentication: SQL Server
Login: sa
Password: P@ssw0rd123!
Database: ad_password_manager
```

#### Using Azure Data Studio

```
Server: localhost
Port: 1433
Authentication: SQL Server
Username: sa
Password: P@ssw0rd123!
```

#### Using Command Line

```bash
# Inside container
docker exec -it ad-password-manager-db /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P P@ssw0rd123!

# Query example
SELECT * FROM audit_logs;
```

## Health Checks

Containers include health checks. View status:

```bash
# Check health
docker ps --format "table {{.Names}}\t{{.Status}}"

# Detailed health
docker inspect --format='{{json .State.Health}}' ad-password-manager-api | jq
```

## Networking

Containers communicate via `ad-network` bridge network:

- **Backend → Database**: `mssql:1433`
- **Frontend → Backend**: Uses Nginx proxy to `http://backend:3001`

### Test Internal Connectivity

```bash
# From backend container
docker exec ad-password-manager-api nc -zv mssql 1433

# From frontend container
docker exec ad-password-manager-ui nc -zv backend 3001
```

## Performance Optimization

### Docker Resource Limits

Edit `docker-compose.yml`:

```yaml
services:
  backend:
    deploy:
      resources:
        limits:
          cpus: '1'
          memory: 512M
        reservations:
          cpus: '0.5'
          memory: 256M
```

### Cleanup & Optimize

```bash
# Remove unused images
docker image prune

# Remove unused volumes
docker volume prune

# Remove everything unused
docker system prune -a
```

## Troubleshooting

### Container Won't Start

```bash
# Check logs
docker compose logs backend

# Restart container
docker compose restart backend

# Check configuration
docker inspect ad-password-manager-api
```

### Database Connection Error

```bash
# Verify database is healthy
docker ps | grep mssql

# Test connection
docker exec ad-password-manager-db /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P P@ssw0rd123! -Q "SELECT 1"
```

### Frontend Can't Connect to Backend

```bash
# Verify backend is running
docker compose ps backend

# Check logs
docker compose logs backend

# Test API
curl http://localhost:3001/api/health
```

### Port Already in Use

```bash
# Find process using port
netstat -ano | findstr :3000

# Kill process (Windows)
taskkill /PID <PID> /F

# Or use different ports in docker-compose.yml
ports:
  - "8000:3000"  # Frontend
  - "8001:3001"  # Backend
  - "1500:1433"  # Database
```

### Out of Disk Space

```bash
# Clean up Docker data
docker system prune -a --volumes

# Check disk usage
docker system df
```

## Production Deployment

### Before Production

1. **Change Passwords**:
   - SQL Server SA password
   - JWT secret (strong, random)
   - Database credentials

2. **Security**:
   - Use environment file: `docker compose --env-file .env.prod up`
   - Enable SSL/TLS
   - Configure firewall rules
   - Use secrets management

3. **Networking**:
   - Run behind reverse proxy (Traefik, nginx)
   - Enable HTTPS
   - Configure rate limiting

4. **Monitoring**:
   - Setup container logging
   - Monitor resource usage
   - Configure alerts
   - Enable audit logging

### Environment File Example

Create `.env.prod`:

```env
# Database
MSSQL_SA_PASSWORD=SuperStrongPassword123!
DB_PASSWORD=SuperStrongPassword123!

# Security
JWT_SECRET=your-very-long-random-secret-key-here-minimum-32-chars
CORS_ORIGIN=https://yourdomain.com

# AD
AD_URL=ldap://your-ad-server.com
AD_BASE_DN=dc=company,dc=com
AD_ADMIN_USER=admin@company.com
AD_ADMIN_PASSWORD=strong_password

# Email
SMTP_HOST=smtp.company.com
SMTP_PORT=587
SMTP_USER=noreply@company.com
SMTP_PASSWORD=email_password

# SMS
TWILIO_ACCOUNT_SID=your_sid
TWILIO_AUTH_TOKEN=your_token
TWILIO_PHONE_NUMBER=+1234567890
```

Start with env file:

```bash
docker compose --env-file .env.prod up -d
```

## Monitoring & Logging

### View Container Logs

```bash
# Real-time logs
docker compose logs -f backend

# Last 50 lines
docker compose logs --tail=50 backend

# Since specific time
docker compose logs --since 2024-05-15 backend
```

### Log Aggregation

For production, consider:
- ELK Stack (Elasticsearch, Logstash, Kibana)
- Splunk
- DataDog
- New Relic
- CloudWatch

## Backup & Restore

### Backup Database

```bash
# Backup SQL Server database
docker exec ad-password-manager-db /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P P@ssw0rd123! -Q "BACKUP DATABASE [ad_password_manager] TO DISK = '/var/opt/mssql/backup/ad_password_manager.bak'"

# Copy backup file
docker cp ad-password-manager-db:/var/opt/mssql/backup/ad_password_manager.bak ./backup/
```

### Restore Database

```bash
# Copy backup file to container
docker cp ./backup/ad_password_manager.bak ad-password-manager-db:/var/opt/mssql/backup/

# Restore
docker exec ad-password-manager-db /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P P@ssw0rd123! -Q "RESTORE DATABASE [ad_password_manager] FROM DISK = '/var/opt/mssql/backup/ad_password_manager.bak'"
```

## Update & Deployment

### Update Application

```bash
# Pull latest code
git pull origin main

# Rebuild containers
docker compose build

# Restart services
docker compose up -d

# Verify deployment
docker compose ps
```

### Zero-Downtime Deployment

```bash
# Build new image
docker compose build backend

# Start new backend container
docker compose up -d backend

# If successful, restart others
docker compose restart frontend
```

## References

- [Docker Documentation](https://docs.docker.com/)
- [Docker Compose Documentation](https://docs.docker.com/compose/)
- [SQL Server Docker Images](https://hub.docker.com/_/microsoft-mssql-server)
- [Node.js Docker Images](https://hub.docker.com/_/node)
- [Nginx Docker Images](https://hub.docker.com/_/nginx)

## Support

For issues:
1. Check logs: `docker compose logs`
2. Verify container health: `docker compose ps`
3. Test connectivity: `docker exec <container> nc -zv <host> <port>`
4. Review configuration in `docker-compose.yml`
