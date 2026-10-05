#!/bin/bash

# Development workflow script for APITable
# Builds images and manages development containers

set -e

# Configuration
COMPOSE_FILE="docker-compose.dev.yml"
ENV_FILE=".env"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

usage() {
    echo "Usage: $0 [COMMAND]"
    echo ""
    echo "Commands:"
    echo "  build        Build all development images"
    echo "  up           Start development environment"
    echo "  down         Stop development environment"
    echo "  restart      Rebuild images and restart environment"
    echo "  logs [svc]   Show logs (optionally for specific service)"
    echo "  shell <svc>  Open shell in running service"
    echo "  status       Show container status"
    echo "  clean        Stop containers and remove images"
    echo "  help         Show this help message"
    echo ""
    echo "Services: web-server, backend-server, room-server, mysql, redis"
}

log() {
    echo -e "${BLUE}[$(date +'%H:%M:%S')]${NC} $1"
}

success() {
    echo -e "${GREEN}[$(date +'%H:%M:%S')]${NC} ✓ $1"
}

warn() {
    echo -e "${YELLOW}[$(date +'%H:%M:%S')]${NC} ⚠ $1"
}

error() {
    echo -e "${RED}[$(date +'%H:%M:%S')]${NC} ✗ $1"
}

check_prerequisites() {
    if ! command -v docker &> /dev/null; then
        error "Docker is not installed or not in PATH"
        exit 1
    fi

    if ! command -v docker-compose &> /dev/null; then
        error "docker-compose is not installed or not in PATH"
        exit 1
    fi

    if [ ! -f "$ENV_FILE" ]; then
        warn ".env file not found. Creating default..."
        create_default_env
    fi
}

create_default_env() {
    cat > "$ENV_FILE" << 'EOF'
# APITable Development Environment
TIMEZONE=UTC

# Database
MYSQL_HOST=mysql
MYSQL_PORT=3306
MYSQL_DATABASE=apitable
MYSQL_USERNAME=apitable
MYSQL_PASSWORD=apitable@com

# Redis
REDIS_HOST=redis
REDIS_PORT=6379
REDIS_PASSWORD=

# Backend
BACKEND_BASE_URL=http://backend-server:8081

# Frontend
PUBLIC_URL=http://localhost:3000
API_BASE_URL=http://localhost:8081/api/v1

# Room Server
SOCKET_URL=http://localhost:3001
NEST_GRPC_URL=localhost:3007
NEST_GRPC_URL_DEV=localhost:3007

# Development
NODE_ENV=development
EOF
    success "Created default .env file"
}

build_images() {
    log "Building development images..."
    
    if [ ! -f "./scripts/build-dev-images.sh" ]; then
        error "Build script not found. Please ensure ./scripts/build-dev-images.sh exists"
        exit 1
    fi

    chmod +x ./scripts/build-dev-images.sh
    ./scripts/build-dev-images.sh
    
    success "Images built successfully"
}

start_services() {
    log "Starting development environment..."
    
    docker-compose -f "$COMPOSE_FILE" up -d
    
    success "Development environment started"
    echo ""
    echo "Services available at:"
    echo "  Frontend:     http://localhost:3000"
    echo "  Backend API:  http://localhost:8081/api/v1"
    echo "  Room Server:  http://localhost:3333"
    echo "  MySQL:        localhost:3306"
    echo "  Redis:        localhost:6379"
    echo ""
    echo "Use '$0 logs' to view logs"
    echo "Use '$0 status' to check service health"
}

stop_services() {
    log "Stopping development environment..."
    docker-compose -f "$COMPOSE_FILE" down
    success "Development environment stopped"
}

restart_services() {
    log "Restarting development environment..."
    build_images
    stop_services
    start_services
}

show_logs() {
    if [ -n "$1" ]; then
        log "Showing logs for service: $1"
        docker-compose -f "$COMPOSE_FILE" logs -f "$1"
    else
        log "Showing logs for all services (Ctrl+C to exit)"
        docker-compose -f "$COMPOSE_FILE" logs -f
    fi
}

open_shell() {
    if [ -z "$1" ]; then
        error "Please specify a service name"
        echo "Available services: web-server, backend-server, room-server, mysql, redis"
        exit 1
    fi

    log "Opening shell in $1..."
    docker-compose -f "$COMPOSE_FILE" exec "$1" /bin/bash 2>/dev/null || \
    docker-compose -f "$COMPOSE_FILE" exec "$1" /bin/sh
}

show_status() {
    log "Container status:"
    docker-compose -f "$COMPOSE_FILE" ps
    
    echo ""
    log "Service health checks:"
    docker-compose -f "$COMPOSE_FILE" exec backend-server curl -sf http://localhost:8081/api/v1/health 2>/dev/null && \
        success "Backend server: healthy" || warn "Backend server: not ready"
    
    docker-compose -f "$COMPOSE_FILE" exec redis redis-cli ping 2>/dev/null | grep -q PONG && \
        success "Redis: healthy" || warn "Redis: not ready"
    
    docker-compose -f "$COMPOSE_FILE" exec mysql mysqladmin ping -h localhost -u root -p${MYSQL_PASSWORD:-apitable@com} 2>/dev/null && \
        success "MySQL: healthy" || warn "MySQL: not ready"
}

clean_environment() {
    log "Cleaning up development environment..."
    
    # Stop and remove containers
    docker-compose -f "$COMPOSE_FILE" down -v --rmi local 2>/dev/null || true
    
    # Remove development images
    docker images --format "table {{.Repository}}:{{.Tag}}" | grep "localhost/apitable.*:dev-latest" | awk '{print $1}' | \
        xargs -r docker rmi 2>/dev/null || true
    
    success "Environment cleaned up"
}

# Main command handling
case "${1:-help}" in
    "build")
        check_prerequisites
        build_images
        ;;
    "up")
        check_prerequisites
        start_services
        ;;
    "down")
        stop_services
        ;;
    "restart")
        check_prerequisites
        restart_services
        ;;
    "logs")
        show_logs "$2"
        ;;
    "shell")
        open_shell "$2"
        ;;
    "status")
        show_status
        ;;
    "clean")
        clean_environment
        ;;
    "help"|*)
        usage
        ;;
esac