#!/bin/bash

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Function to show help
show_help() {
    echo "Usage: $0 [COMMAND]"
    echo ""
    echo "Available commands:"
    echo "  build      Build the production Docker image"
    echo "  dev        Start development environment"
    echo "  start      Start production containers"
    echo "  stop       Stop all containers"
    echo "  restart    Restart production containers"
    echo "  logs       Show container logs"
    echo "  clean      Remove containers and images"
    echo "  help       Show this help message"
    echo ""
    echo "Examples:"
    echo "  $0 build      # Build production image"
    echo "  $0 dev        # Start development server"
    echo "  $0 start      # Start production server"
    echo "  $0 logs       # View logs"
}

# Build production image
build_production() {
    print_status "Building production Docker image..."
    docker-compose build ping-dashboard
    if [ $? -eq 0 ]; then
        print_success "Production image built successfully!"
    else
        print_error "Failed to build production image"
        exit 1
    fi
}

# Start development environment
start_dev() {
    print_status "Starting development environment..."
    docker-compose --profile dev up -d ping-dashboard-dev
    if [ $? -eq 0 ]; then
        print_success "Development server started!"
        print_status "Access your application at: http://localhost:3000"
        print_status "To view logs: $0 logs"
    else
        print_error "Failed to start development server"
        exit 1
    fi
}

# Start production containers
start_production() {
    print_status "Starting production containers..."
    docker-compose up -d ping-dashboard
    if [ $? -eq 0 ]; then
        print_success "Production server started!"
        print_status "Access your application at: http://localhost:8080"
        print_status "Health check: http://localhost:8080/health"
    else
        print_error "Failed to start production server"
        exit 1
    fi
}

# Stop all containers
stop_containers() {
    print_status "Stopping all containers..."
    docker-compose down
    print_success "All containers stopped"
}

# Restart production containers
restart_production() {
    print_status "Restarting production containers..."
    docker-compose restart ping-dashboard
    print_success "Production containers restarted"
}

# Show logs
show_logs() {
    echo "Choose which logs to view:"
    echo "1) Production logs"
    echo "2) Development logs"
    echo "3) All logs"
    read -p "Enter choice (1-3): " choice
    
    case $choice in
        1)
            docker-compose logs -f ping-dashboard
            ;;
        2)
            docker-compose logs -f ping-dashboard-dev
            ;;
        3)
            docker-compose logs -f
            ;;
        *)
            print_error "Invalid choice"
            exit 1
            ;;
    esac
}

# Clean up containers and images
clean_up() {
    print_warning "This will remove all containers and images. Are you sure? (y/N)"
    read -p "Confirm: " confirm
    
    if [ "$confirm" = "y" ] || [ "$confirm" = "Y" ]; then
        print_status "Stopping containers..."
        docker-compose down
        
        print_status "Removing images..."
        docker image prune -f
        docker-compose down --rmi all --volumes --remove-orphans
        
        print_success "Cleanup completed"
    else
        print_status "Cleanup cancelled"
    fi
}

# Main script logic
case "$1" in
    build)
        build_production
        ;;
    dev)
        start_dev
        ;;
    start)
        start_production
        ;;
    stop)
        stop_containers
        ;;
    restart)
        restart_production
        ;;
    logs)
        show_logs
        ;;
    clean)
        clean_up
        ;;
    help|--help|-h)
        show_help
        ;;
    "")
        print_error "No command specified"
        show_help
        exit 1
        ;;
    *)
        print_error "Unknown command: $1"
        show_help
        exit 1
        ;;
esac 