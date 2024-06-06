#!/usr/bin/env bash

# Print cool logo for the script
echo "📚 Bookstack Docker automation tool 1.0v 📚"
echo "-----------------------------------------"
echo -e "🚀 Developed by: Antonio Gagliarducci 🚀"
echo "-----------------------------------------"

# Function to check if Docker is installed
check_docker_installed() {
    if ! command -v docker &> /dev/null; then
        echo "Error: Docker is not installed."
        exit 1
    fi
}

# Function to start the services
start_service() {
    docker compose up -d || { echo "Error: Failed to start the service."; exit 1; }
}

# Function to stop the services
stop_service() {
    docker compose down || { echo "Error: Failed to stop the service."; exit 1; }
}

# Function to show logs of all containers
show_logs() {
    docker compose logs
}

# Function to show logs of a specific container
show_container_logs() {
    docker logs "$1"
}

# Function to update and restart the services
update_service() {
    (docker compose pull && docker compose up -d) || { echo "Error: Failed to update and restart."; exit 1; }
}

# Function to restart the services
restart_service() {
    docker compose restart || { echo "Error: Failed to restart the service."; exit 1; }
}

# Function to show the status of the services
show_service_status() {
    docker compose ps
}

# Function to enter inside a container
enter_container() {
    container_name="$1"
    case "$container_name" in
        caddy | bookstack | bookstack_db)
            docker exec -it "$container_name" sh
            ;;
        *)
            echo "Error: Invalid container name '$container_name'. Available ➡️ (caddy, bookstack, bookstack_db)"
            exit 1
            ;;
    esac
}

# Function to show the help page
show_help() {
    echo "Usage: $0 {start|stop|logs|logs_caddy|logs_bookstack|logs_bookstack_db|update|restart|status|enter}"
    echo "Description:"
    echo "  start                  - Start the Docker Compose service"
    echo "  stop                   - Stop the Docker Compose service"
    echo "  logs                   - Show logs of all containers"
    echo "  logs_caddy             - Show logs of the Caddy container"
    echo "  logs_bookstack         - Show logs of the Bookstack container"
    echo "  logs_bookstack_db      - Show logs of the Bookstack DB container"
    echo "  update                 - Update all containers and restart"
    echo "  restart                - Restart the Docker Compose service"
    echo "  status                 - Show status of the Docker Compose service"
    echo "  enter <container_name> - Enter inside a container [caddy|bookstack|bookstack_db]"
    echo "  help                   - Show this help message"
}

# Main script
check_docker_installed

# Handle command line arguments
case "$1" in
    start)
        start_service
        ;;
    stop)
        stop_service
        ;;
    logs)
        show_logs
        ;;
    logs_caddy)
        show_container_logs caddy
        ;;
    logs_bookstack)
        show_container_logs bookstack
        ;;
    logs_bookstack_db)
        show_container_logs bookstack_db
        ;;
    update)
        update_service
        ;;
    restart)
        restart_service
        ;;
    status)
        show_service_status
        ;;
    enter)
        if [ -z "$2" ]; then
            echo "Error: Please specify a container name."
            exit 1
        fi
        enter_container "$2"
        ;;
    help)
        show_help
        ;;
    *)
        echo -e "Invalid option! See below: \n"
        show_help
        exit 1
        ;;
esac

echo "-----------------------------------------"
# Exit successfully
echo -e "🚚🚚💨 End of the script!\nHave a good day :)"

exit 0
