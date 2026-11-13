#!/bin/bash
# Docker Manager Script for AD Password Manager
# This script helps manage Docker containers

set -e

show_menu() {
    echo ""
    echo "======================================"
    echo "AD Password Manager - Docker Manager"
    echo "======================================"
    echo "1. Start Production Containers"
    echo "2. Start Development Containers"
    echo "3. Stop All Containers"
    echo "4. View Logs"
    echo "5. Rebuild Images"
    echo "6. Access Container Shell"
    echo "7. Database Tools"
    echo "8. Cleanup Docker"
    echo "9. Health Check"
    echo "0. Exit"
    echo ""
    read -p "Select an option (0-9): " choice
}

start_prod() {
    echo "Starting Production Containers..."
    docker compose up -d
    echo ""
    echo "✓ Containers started! Access at:"
    echo "  - Frontend: http://localhost:3000"
    echo "  - API: http://localhost:3001/api"
    echo "  - Database: localhost:1433"
}

start_dev() {
    echo "Starting Development Containers..."
    docker compose -f docker-compose.dev.yml up -d
    echo ""
    echo "✓ Development containers started! Access at:"
    echo "  - Frontend: http://localhost:3000 (with hot reload)"
    echo "  - API: http://localhost:3001/api"
    echo "  - Database: localhost:1433"
}

stop_all() {
    echo "Stopping all containers..."
    docker compose stop || true
    docker compose -f docker-compose.dev.yml stop || true
    echo "✓ All containers stopped."
}

view_logs() {
    echo ""
    read -p "Enter service name (backend/frontend/mssql) or press Enter for all: " service
    if [ -z "$service" ]; then
        docker compose logs -f
    else
        docker compose logs -f "$service"
    fi
}

rebuild() {
    echo "Rebuilding images..."
    read -p "Rebuild (all/backend/frontend): " rebuild_type
    if [ "$rebuild_type" = "all" ]; then
        docker compose build
    else
        docker compose build "$rebuild_type"
    fi
    echo "✓ Build completed."
}

shell_access() {
    echo ""
    read -p "Enter container (backend/frontend/mssql): " container
    case "$container" in
        backend)
            docker exec -it ad-password-manager-api sh
            ;;
        frontend)
            docker exec -it ad-password-manager-ui sh
            ;;
        mssql)
            docker exec -it ad-password-manager-db /bin/bash
            ;;
        *)
            echo "Invalid container name."
            ;;
    esac
}

database_tools() {
    echo ""
    echo "Database Tools:"
    echo "1. Connect to Database"
    echo "2. View Database Size"
    echo "3. List Tables"
    echo "4. Backup Database"
    echo "5. View Audit Logs"
    echo ""
    read -p "Select (1-5): " db_choice
    
    case "$db_choice" in
        1)
            echo "Connecting to database..."
            docker exec -it ad-password-manager-db /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P P@ssw0rd123!
            ;;
        2)
            echo "Database size:"
            docker exec ad-password-manager-db /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P P@ssw0rd123! -Q "EXEC sp_spaceused"
            ;;
        3)
            echo "Tables in database:"
            docker exec ad-password-manager-db /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P P@ssw0rd123! -Q "SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_TYPE = 'BASE TABLE'"
            ;;
        4)
            echo "Backing up database..."
            BACKUP_NAME="backup_$(date +%Y%m%d_%H%M%S).bak"
            docker exec ad-password-manager-db /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P P@ssw0rd123! -Q "BACKUP DATABASE [ad_password_manager] TO DISK = '/var/opt/mssql/backup/$BACKUP_NAME'"
            echo "✓ Backup completed: $BACKUP_NAME"
            ;;
        5)
            echo "Recent audit logs:"
            docker exec ad-password-manager-db /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P P@ssw0rd123! -Q "SELECT TOP 20 * FROM audit_logs ORDER BY timestamp DESC"
            ;;
        *)
            echo "Invalid option."
            ;;
    esac
}

cleanup() {
    echo ""
    read -p "This will remove unused Docker resources. Continue? (yes/no): " confirm
    if [ "$confirm" = "yes" ]; then
        echo "Cleaning up Docker..."
        docker system prune -a --volumes -f
        echo "✓ Cleanup completed."
    else
        echo "Cleanup cancelled."
    fi
}

health_check() {
    echo ""
    echo "Container Status:"
    docker compose ps
    echo ""
    echo "Detailed Health Info:"
    docker ps --format "table {{.Names}}\t{{.Status}}" || true
}

# Main loop
while true; do
    show_menu
    
    case $choice in
        1) start_prod ;;
        2) start_dev ;;
        3) stop_all ;;
        4) view_logs ;;
        5) rebuild ;;
        6) shell_access ;;
        7) database_tools ;;
        8) cleanup ;;
        9) health_check ;;
        0) 
            echo "Exiting..."
            exit 0
            ;;
        *)
            echo "Invalid option. Please try again."
            ;;
    esac
    
    echo ""
    read -p "Press Enter to continue..."
done
