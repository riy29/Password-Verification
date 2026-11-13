@echo off
REM Docker Startup Script for AD Password Manager
REM This script helps manage Docker containers

setlocal enabledelayedexpansion

:menu
echo.
echo ======================================
echo AD Password Manager - Docker Manager
echo ======================================
echo 1. Start Production Containers
echo 2. Start Development Containers
echo 3. Stop All Containers
echo 4. View Logs
echo 5. Rebuild Images
echo 6. Access Container Shell
echo 7. Database Tools
echo 8. Cleanup Docker
echo 9. Health Check
echo 0. Exit
echo.
set /p choice="Select an option (0-9): "

if "%choice%"=="1" goto start_prod
if "%choice%"=="2" goto start_dev
if "%choice%"=="3" goto stop_all
if "%choice%"=="4" goto view_logs
if "%choice%"=="5" goto rebuild
if "%choice%"=="6" goto shell
if "%choice%"=="7" goto database
if "%choice%"=="8" goto cleanup
if "%choice%"=="9" goto health
if "%choice%"=="0" goto end
goto menu

:start_prod
echo Starting Production Containers...
docker compose up -d
echo.
echo Containers started! Access at:
echo - Frontend: http://localhost:3000
echo - API: http://localhost:3001/api
echo - Database: localhost:1433
pause
goto menu

:start_dev
echo Starting Development Containers...
docker compose -f docker-compose.dev.yml up -d
echo.
echo Development containers started! Access at:
echo - Frontend: http://localhost:3000 (with hot reload)
echo - API: http://localhost:3001/api
echo - Database: localhost:1433
pause
goto menu

:stop_all
echo Stopping all containers...
docker compose stop
docker compose -f docker-compose.dev.yml stop
echo All containers stopped.
pause
goto menu

:view_logs
echo.
set /p service="Enter service name (backend/frontend/mssql) or press Enter for all: "
if "%service%"=="" (
    docker compose logs -f
) else (
    docker compose logs -f %service%
)
pause
goto menu

:rebuild
echo Rebuilding images...
set /p rebuild_type="Rebuild (all/backend/frontend): "
if "%rebuild_type%"=="all" (
    docker compose build
) else (
    docker compose build %rebuild_type%
)
echo Build completed.
pause
goto menu

:shell
echo.
set /p container="Enter container (backend/frontend/mssql): "
if "%container%"=="backend" (
    docker exec -it ad-password-manager-api sh
) else if "%container%"=="frontend" (
    docker exec -it ad-password-manager-ui sh
) else if "%container%"=="mssql" (
    docker exec -it ad-password-manager-db /bin/bash
) else (
    echo Invalid container name.
)
pause
goto menu

:database
echo.
echo Database Tools:
echo 1. Connect to Database
echo 2. View Database Size
echo 3. List Tables
echo 4. Backup Database
echo 5. View Audit Logs
echo.
set /p db_choice="Select (1-5): "

if "%db_choice%"=="1" (
    echo Connecting to database...
    docker exec -it ad-password-manager-db /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P P@ssw0rd123!
) else if "%db_choice%"=="2" (
    echo Database size:
    docker exec ad-password-manager-db /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P P@ssw0rd123! -Q "EXEC sp_spaceused"
) else if "%db_choice%"=="3" (
    echo Tables in database:
    docker exec ad-password-manager-db /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P P@ssw0rd123! -Q "SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_TYPE = 'BASE TABLE'"
) else if "%db_choice%"=="4" (
    echo Backing up database...
    docker exec ad-password-manager-db /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P P@ssw0rd123! -Q "BACKUP DATABASE [ad_password_manager] TO DISK = '/var/opt/mssql/backup/backup_!date:~10,4!!date:~4,2!!date:~7,2!_!time:~0,2!!time:~3,2!.bak'"
    echo Backup completed.
) else if "%db_choice%"=="5" (
    echo Recent audit logs:
    docker exec ad-password-manager-db /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P P@ssw0rd123! -Q "SELECT TOP 20 * FROM audit_logs ORDER BY timestamp DESC"
)
pause
goto menu

:cleanup
echo.
echo This will remove unused Docker images, volumes, and networks.
set /p confirm="Are you sure? (yes/no): "
if /i "%confirm%"=="yes" (
    echo Cleaning up Docker...
    docker system prune -a --volumes
    echo Cleanup completed.
) else (
    echo Cleanup cancelled.
)
pause
goto menu

:health
echo.
echo Container Health Status:
docker compose ps
echo.
echo Detailed health info:
docker ps --format "table {{.Names}}\t{{.Status}}"
pause
goto menu

:end
echo Exiting...
exit /b 0
