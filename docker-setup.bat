@echo off
REM Initialize AD Password Manager Docker Environment
REM Run this script once to set up everything

echo.
echo ========================================
echo AD Password Manager - Docker Setup
echo ========================================
echo.

REM Check if Docker is installed
docker --version >nul 2>&1
if errorlevel 1 (
    echo [ERROR] Docker is not installed or not in PATH
    echo Please install Docker Desktop from https://www.docker.com/products/docker-desktop
    pause
    exit /b 1
)

echo [OK] Docker is installed

REM Check if docker compose is available
docker compose version >nul 2>&1
if errorlevel 1 (
    echo [ERROR] Docker Compose is not available
    pause
    exit /b 1
)

echo [OK] Docker Compose is available

REM Create .env file if it doesn't exist
if not exist ".env" (
    echo [INFO] Creating .env file...
    (
        echo # Database
        echo MSSQL_SA_PASSWORD=P@ssw0rd123!
        echo DB_HOST=mssql
        echo DB_PORT=1433
        echo DB_NAME=ad_password_manager
        echo DB_USER=sa
        echo.
        echo # Active Directory - UPDATE THESE
        echo AD_URL=ldap://your-ad-server.com
        echo AD_BASE_DN=dc=company,dc=com
        echo AD_ADMIN_USER=admin@company.com
        echo AD_ADMIN_PASSWORD=your_ad_password
        echo.
        echo # JWT Security
        echo JWT_SECRET=change-this-to-a-strong-secret-key-in-production
        echo JWT_EXPIRY=24h
        echo.
        echo # Email Configuration - UPDATE THESE
        echo SMTP_HOST=smtp.gmail.com
        echo SMTP_PORT=587
        echo SMTP_USER=your-email@gmail.com
        echo SMTP_PASSWORD=your-app-password
        echo SMTP_FROM=noreply@company.com
        echo.
        echo # SMS Configuration (Twilio) - UPDATE THESE
        echo TWILIO_ACCOUNT_SID=your_twilio_account_sid
        echo TWILIO_AUTH_TOKEN=your_twilio_auth_token
        echo TWILIO_PHONE_NUMBER=+1234567890
        echo.
        echo # OTP Settings
        echo OTP_VALIDITY=300
        echo OTP_EXPIRY=5
        echo.
        echo # Frontend
        echo REACT_APP_API_URL=http://localhost:3001/api
        echo REACT_APP_ENV=development
        echo.
        echo # CORS
        echo CORS_ORIGIN=http://localhost:3000
    ) > .env
    echo [OK] Created .env file - please edit with your configuration
)

REM Create backup directory
if not exist "backup" (
    echo [INFO] Creating backup directory...
    mkdir backup
    echo [OK] Created backup directory
)

REM Pull latest images
echo.
echo [INFO] Pulling latest Docker images...
docker pull node:18-alpine
docker pull nginx:alpine
docker pull mcr.microsoft.com/mssql/server:2019-latest
echo [OK] Images pulled

REM Build images
echo.
echo [INFO] Building Docker images...
docker compose build
if errorlevel 1 (
    echo [ERROR] Failed to build images
    pause
    exit /b 1
)
echo [OK] Images built successfully

REM Create volumes
echo.
echo [INFO] Creating volumes...
docker volume create mssql_data
echo [OK] Volumes created

echo.
echo ========================================
echo Setup Complete!
echo ========================================
echo.
echo Next steps:
echo 1. Edit .env file with your configuration
echo 2. Run: docker compose up -d
echo 3. Open: http://localhost:3000
echo.
echo Quick commands:
echo   Start:  docker compose up -d
echo   Stop:   docker compose stop
echo   Logs:   docker compose logs -f
echo   Status: docker compose ps
echo.
echo For more info, see DOCKER-QUICK-REF.md or DOCKER.md
echo.
pause
