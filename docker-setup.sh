#!/bin/bash
# Initialize AD Password Manager Docker Environment
# Run this script once to set up everything

set -e

echo ""
echo "========================================"
echo "AD Password Manager - Docker Setup"
echo "========================================"
echo ""

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    echo "[ERROR] Docker is not installed"
    echo "Please install Docker from https://www.docker.com/products/docker-desktop"
    exit 1
fi

echo "[OK] Docker is installed"

# Check if docker compose is available
if ! docker compose version &> /dev/null; then
    echo "[ERROR] Docker Compose is not available"
    exit 1
fi

echo "[OK] Docker Compose is available"

# Create .env file if it doesn't exist
if [ ! -f .env ]; then
    echo "[INFO] Creating .env file..."
    cat > .env << 'EOF'
# Database
MSSQL_SA_PASSWORD=P@ssw0rd123!
DB_HOST=mssql
DB_PORT=1433
DB_NAME=ad_password_manager
DB_USER=sa

# Active Directory - UPDATE THESE
AD_URL=ldap://your-ad-server.com
AD_BASE_DN=dc=company,dc=com
AD_ADMIN_USER=admin@company.com
AD_ADMIN_PASSWORD=your_ad_password

# JWT Security
JWT_SECRET=change-this-to-a-strong-secret-key-in-production
JWT_EXPIRY=24h

# Email Configuration - UPDATE THESE
SMTP_HOST=smtp.gmail.com
SMTP_PORT=587
SMTP_USER=your-email@gmail.com
SMTP_PASSWORD=your-app-password
SMTP_FROM=noreply@company.com

# SMS Configuration (Twilio) - UPDATE THESE
TWILIO_ACCOUNT_SID=your_twilio_account_sid
TWILIO_AUTH_TOKEN=your_twilio_auth_token
TWILIO_PHONE_NUMBER=+1234567890

# OTP Settings
OTP_VALIDITY=300
OTP_EXPIRY=5

# Frontend
REACT_APP_API_URL=http://localhost:3001/api
REACT_APP_ENV=development

# CORS
CORS_ORIGIN=http://localhost:3000
EOF
    echo "[OK] Created .env file - please edit with your configuration"
fi

# Create backup directory
if [ ! -d "backup" ]; then
    echo "[INFO] Creating backup directory..."
    mkdir -p backup
    echo "[OK] Created backup directory"
fi

# Pull latest images
echo ""
echo "[INFO] Pulling latest Docker images..."
docker pull node:18-alpine
docker pull nginx:alpine
docker pull mcr.microsoft.com/mssql/server:2019-latest
echo "[OK] Images pulled"

# Build images
echo ""
echo "[INFO] Building Docker images..."
docker compose build
if [ $? -ne 0 ]; then
    echo "[ERROR] Failed to build images"
    exit 1
fi
echo "[OK] Images built successfully"

# Create volumes
echo ""
echo "[INFO] Creating volumes..."
docker volume create mssql_data || true
echo "[OK] Volumes created"

echo ""
echo "========================================"
echo "Setup Complete!"
echo "========================================"
echo ""
echo "Next steps:"
echo "1. Edit .env file with your configuration"
echo "2. Run: docker compose up -d"
echo "3. Open: http://localhost:3000"
echo ""
echo "Quick commands:"
echo "  Start:  docker compose up -d"
echo "  Stop:   docker compose stop"
echo "  Logs:   docker compose logs -f"
echo "  Status: docker compose ps"
echo ""
echo "For more info, see DOCKER-QUICK-REF.md or DOCKER.md"
echo ""
