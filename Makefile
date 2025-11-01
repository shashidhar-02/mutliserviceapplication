# Makefile for Multi-Service Docker Application

.PHONY: help build up down logs clean test health rebuild

# Default target
help:
	@echo "Multi-Service Docker Application"
	@echo ""
	@echo "Available targets:"
	@echo "  build      Build all Docker images"
	@echo "  up         Start all services"
	@echo "  down       Stop all services"
	@echo "  logs       View logs from all services"
	@echo "  clean      Remove all containers, images, and volumes"
	@echo "  test       Run health checks on all services"
	@echo "  health     Display health status"
	@echo "  rebuild    Clean build and restart everything"
	@echo "  dev        Start in development mode"
	@echo "  prod       Start in production mode"

# Build all images
build:
	@echo "Building custom base images..."
	docker build -f docker-base-images/node-base.Dockerfile -t multiservice/node-base:latest docker-base-images/
	docker build -f docker-base-images/nginx-base.Dockerfile -t multiservice/nginx-base:latest docker-base-images/
	@echo "Building application images..."
	docker-compose build --build-arg BUILDKIT_INLINE_CACHE=1

# Start all services
up:
	@echo "Starting all services..."
	mkdir -p logs/nginx logs/app logs/mongodb logs/redis
	docker-compose up -d
	@echo "Services started. Use 'make logs' to view logs."

# Stop all services
down:
	@echo "Stopping all services..."
	docker-compose down

# View logs
logs:
	docker-compose logs -f

# Clean everything
clean:
	@echo "Cleaning up..."
	docker-compose down -v --rmi all --remove-orphans
	docker system prune -f
	@echo "Cleanup complete."

# Run health checks
test:
	@echo "Running health checks..."
	./health-monitor.sh

# Display health status
health:
	@echo "Service Health Status:"
	@docker-compose ps
	@echo ""
	@echo "Detailed Health Checks:"
	@./health-monitor.sh

# Rebuild everything
rebuild: clean build up
	@echo "Rebuild complete!"

# Development mode
dev:
	@echo "Starting in development mode..."
	mkdir -p logs/nginx logs/app logs/mongodb logs/redis
	docker-compose -f docker-compose.yml -f docker-compose.dev.yml up -d

# Production mode
prod: build
	@echo "Starting in production mode..."
	mkdir -p logs/nginx logs/app logs/mongodb logs/redis
	chmod +x health-monitor.sh nginx/healthcheck.sh web-app/healthcheck.sh
	docker-compose up -d
	@echo "Production deployment complete!"
	@echo "Access the application at: http://localhost"

# Show container resource usage
stats:
	docker stats --no-stream

# Backup data
backup:
	@echo "Creating backup..."
	mkdir -p backups
	docker exec multiservice-mongodb mongodump --out /tmp/backup
	docker cp multiservice-mongodb:/tmp/backup ./backups/mongodb-$(shell date +%Y%m%d-%H%M%S)
	@echo "Backup created in ./backups/"

# Restore data (requires BACKUP_DIR variable)
restore:
	@if [ -z "$(BACKUP_DIR)" ]; then echo "Please specify BACKUP_DIR=path/to/backup"; exit 1; fi
	@echo "Restoring from $(BACKUP_DIR)..."
	docker cp $(BACKUP_DIR) multiservice-mongodb:/tmp/restore
	docker exec multiservice-mongodb mongorestore /tmp/restore
	@echo "Restore complete!"