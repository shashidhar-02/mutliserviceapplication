#!/bin/bash

# Production deployment script
set -e

echo "🚀 Starting Multi-Service Application Deployment"

# Check prerequisites
echo "📋 Checking prerequisites..."

if ! command -v docker &> /dev/null; then
    echo "❌ Docker is not installed"
    exit 1
fi

if ! command -v docker-compose &> /dev/null; then
    echo "❌ Docker Compose is not installed"
    exit 1
fi

# Check Docker daemon
if ! docker info &> /dev/null; then
    echo "❌ Docker daemon is not running"
    exit 1
fi

echo "✅ Prerequisites check passed"

# Build custom base images
echo "🏗️ Building custom base images..."
docker build -f docker-base-images/node-base.Dockerfile -t multiservice/node-base:latest docker-base-images/
docker build -f docker-base-images/nginx-base.Dockerfile -t multiservice/nginx-base:latest docker-base-images/

# Create necessary directories
echo "📁 Creating directories..."
mkdir -p logs/nginx logs/app logs/mongodb logs/redis

# Set proper permissions
chmod 755 logs
chmod 755 logs/*

# Make scripts executable
echo "🔧 Setting up scripts..."
chmod +x health-monitor.sh
chmod +x nginx/healthcheck.sh
chmod +x web-app/healthcheck.sh

# Pull latest images
echo "📥 Pulling latest images..."
docker-compose pull

# Build and start services
echo "🚀 Building and starting services..."
docker-compose up --build -d

# Wait for services to be healthy
echo "⏳ Waiting for services to be healthy..."
sleep 30

# Check health
echo "🏥 Checking service health..."
./health-monitor.sh

# Show status
echo "📊 Service Status:"
docker-compose ps

echo ""
echo "🎉 Deployment completed successfully!"
echo ""
echo "📍 Access points:"
echo "   Main Application: http://localhost"
echo "   API Health Check: http://localhost/health"
echo "   Direct API: http://localhost:3000"
echo "   Direct Frontend: http://localhost:3001"
echo ""
echo "🔧 Management commands:"
echo "   View logs: docker-compose logs -f"
echo "   Stop services: docker-compose down"
echo "   Update services: docker-compose up --build -d"
echo ""