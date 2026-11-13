# Docker Quick Reference

## 🚀 Quick Start (30 seconds)

**Windows:**
```bash
cd PMP
docker compose up -d
start http://localhost:3000
```

**macOS/Linux:**
```bash
cd PMP
docker compose up -d
open http://localhost:3000
```

Access points:
- 🌐 **Frontend**: http://localhost:3000
- 🔌 **API**: http://localhost:3001/api
- 💾 **Database**: localhost:1433

---

## 📋 Essential Commands

### Start Services

```bash
# Production containers
docker compose up -d

# Development containers (hot reload)
docker compose -f docker-compose.dev.yml up -d

# Build before running
docker compose up -d --build

# View real-time logs
docker compose logs -f
```

### Stop & Manage

```bash
# Stop containers (data persists)
docker compose stop

# Start stopped containers
docker compose start

# Restart containers
docker compose restart

# Remove containers (keep data)
docker compose down

# Remove containers & data
docker compose down -v
```

### View Status

```bash
# Show running containers
docker compose ps

# View logs
docker compose logs -f [service]

# Container stats
docker stats

# Health status
docker ps --format "table {{.Names}}\t{{.Status}}"
```

---

## 🛠️ Container Operations

### Access Container Shell

```bash
# Backend shell
docker exec -it ad-password-manager-api sh

# Frontend shell
docker exec -it ad-password-manager-ui sh

# Database shell
docker exec -it ad-password-manager-db /bin/bash
```

### Execute Commands

```bash
# Run command in backend
docker exec ad-password-manager-api npm list

# Run query in database
docker exec ad-password-manager-db sqlcmd -S localhost -U sa -P P@ssw0rd123! -Q "SELECT @@VERSION"
```

### Copy Files

```bash
# Copy from container
docker cp ad-password-manager-api:/app/dist ./backup/

# Copy to container
docker cp ./file.sql ad-password-manager-db:/var/opt/mssql/
```

---

## 🗄️ Database Operations

### Connect to Database

**SQL Server Management Studio:**
- Server: `localhost,1433`
- Login: `sa`
- Password: `P@ssw0rd123!`

**Command Line:**
```bash
docker exec -it ad-password-manager-db /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P P@ssw0rd123!
```

### Common Queries

```sql
-- Check database size
EXEC sp_spaceused;

-- List all tables
SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES;

-- View audit logs
SELECT TOP 100 * FROM audit_logs ORDER BY timestamp DESC;

-- Check user security answers
SELECT * FROM user_security_answers;

-- View password reset sessions
SELECT * FROM password_reset_sessions;
```

### Backup Database

```bash
# Create backup
docker exec ad-password-manager-db /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P P@ssw0rd123! -Q "BACKUP DATABASE [ad_password_manager] TO DISK = '/var/opt/mssql/backup/backup.bak'"

# Copy backup to host
docker cp ad-password-manager-db:/var/opt/mssql/backup/backup.bak ./backup/
```

---

## 🔧 Configuration

### Environment Variables

Edit in `docker-compose.yml` or `docker-compose.dev.yml`:

```yaml
environment:
  # Database
  DB_HOST: mssql
  DB_PORT: 1433
  DB_NAME: ad_password_manager
  DB_USER: sa
  DB_PASSWORD: P@ssw0rd123!
  
  # Active Directory
  AD_URL: ldap://your-ad-server.com
  AD_BASE_DN: dc=company,dc=com
  
  # Security
  JWT_SECRET: your-secret-key
  CORS_ORIGIN: http://localhost:3000
```

### Use .env File

```bash
# Create .env file
cat > .env << EOF
MSSQL_SA_PASSWORD=NewPassword123!
JWT_SECRET=your-secret-key
AD_URL=ldap://your-server.com
EOF

# Run with env file
docker compose --env-file .env up -d
```

---

## 🐛 Troubleshooting

### Container won't start

```bash
# Check logs
docker compose logs backend

# Inspect container
docker inspect ad-password-manager-api

# Restart container
docker compose restart backend
```

### Port already in use

```bash
# Find process using port (Windows)
netstat -ano | findstr :3000

# Kill process
taskkill /PID <PID> /F

# Or change ports in docker-compose.yml
ports:
  - "8000:3000"  # Frontend
  - "8001:3001"  # Backend
```

### Database connection error

```bash
# Test database connection
docker exec ad-password-manager-db sqlcmd -S localhost -U sa -P P@ssw0rd123! -Q "SELECT 1"

# Check database volume
docker volume ls | grep mssql

# Inspect volume
docker volume inspect mssql_data
```

### Frontend can't reach backend

```bash
# Test from frontend container
docker exec ad-password-manager-ui wget -O- http://backend:3001/api/health

# Check network
docker network inspect ad-network

# Restart networking
docker compose restart frontend
```

---

## 📊 Performance Tuning

### Resource Limits

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

### Clean Up

```bash
# Remove unused images
docker image prune

# Remove unused volumes
docker volume prune

# Remove everything unused
docker system prune -a -f

# Check disk usage
docker system df
```

---

## 🔒 Security

### Change Default Password

1. Edit `docker-compose.yml`:
```yaml
mssql:
  environment:
    MSSQL_SA_PASSWORD: YourNewStrongPassword123!
```

2. Update backend environment:
```yaml
backend:
  environment:
    DB_PASSWORD: YourNewStrongPassword123!
```

3. Restart containers:
```bash
docker compose restart
```

### Enable HTTPS (Production)

```yaml
frontend:
  ports:
    - "443:443"
  volumes:
    - ./certs/cert.pem:/etc/nginx/certs/cert.pem
    - ./certs/key.pem:/etc/nginx/certs/key.pem
```

---

## 📈 Monitoring

### Real-time Monitoring

```bash
# Watch container stats
docker stats --no-stream

# Continuous monitoring
watch 'docker ps --format "table {{.Names}}\t{{.CPUPerc}}\t{{.MemUsage}}"'
```

### Log Analysis

```bash
# View logs with timestamps
docker compose logs --timestamps -f backend

# Search logs
docker compose logs backend | grep "error"

# Last N lines
docker compose logs --tail=50 backend
```

---

## 🔄 Updates & Deployment

### Update Code

```bash
# Pull latest code
git pull

# Rebuild images
docker compose build

# Restart services
docker compose up -d
```

### Rolling Update

```bash
# Build new backend
docker compose build backend

# Restart only backend
docker compose up -d backend

# Test changes
curl http://localhost:3001/api/health

# If OK, restart frontend
docker compose restart frontend
```

---

## 🗂️ File Locations

```
PMP/
├── docker-compose.yml         # Production config
├── docker-compose.dev.yml     # Development config
├── docker-manager.bat         # Windows manager
├── docker-manager.sh          # Linux/Mac manager
├── DOCKER.md                  # Full documentation
├── DOCKER-ARCHITECTURE.md     # Architecture details
├── backend/
│   ├── Dockerfile             # Production image
│   ├── Dockerfile.dev         # Development image
│   ├── .dockerignore
│   └── src/
├── frontend/
│   ├── Dockerfile             # Production image
│   ├── Dockerfile.dev         # Development image
│   ├── nginx.conf
│   ├── .dockerignore
│   └── src/
```

---

## 🎯 Common Tasks

### Deploy to Production

```bash
# 1. Update configuration
vim docker-compose.yml

# 2. Build images
docker compose build

# 3. Start services
docker compose up -d

# 4. Verify health
docker compose ps

# 5. Check logs
docker compose logs -f
```

### Switch Environments

```bash
# Switch to development
docker compose -f docker-compose.dev.yml down
docker compose -f docker-compose.dev.yml up -d

# Switch back to production
docker compose down
docker compose up -d
```

### Reset Everything

```bash
# Stop all
docker compose down -v

# Clean images
docker image prune -a -f

# Start fresh
docker compose up -d --build
```

---

## 📞 Quick Help

Use the helper scripts:

**Windows:**
```cmd
docker-manager.bat
```

**Linux/Mac:**
```bash
chmod +x docker-manager.sh
./docker-manager.sh
```

---

## 🔗 Useful Links

- [Docker Documentation](https://docs.docker.com)
- [Docker Compose Docs](https://docs.docker.com/compose)
- [Full Guide](./DOCKER.md)
- [Architecture](./DOCKER-ARCHITECTURE.md)
- [Main README](./README.md)

---

## ⚡ Performance Baseline

```
Component        Memory      CPU      Startup
─────────────────────────────────────────────
Frontend (Nginx)  ~50 MB     Low      ~2s
Backend (Node)    ~200 MB    Medium   ~5s
Database (SQL)    ~512 MB    Medium   ~10s
─────────────────────────────────────────────
Total            ~762 MB    Medium   ~17s
```

---

## 📝 Log Levels

```bash
# Verbose logging
docker compose logs -f

# Error only
docker compose logs -f | grep -i error

# By service
docker compose logs -f backend
docker compose logs -f frontend
docker compose logs -f mssql
```

---

**💡 Tip**: Save these commands in a text editor for quick access!
