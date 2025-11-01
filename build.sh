#!/bin/bash

# Build script with proper dependency order
set -e

echo "🔨 Multi-Service Application Build Script"
echo "Building components in correct dependency order..."

# Step 1: Build custom base images first
echo ""
echo "📦 Step 1: Building custom base images..."
echo "Building Node.js base image..."
docker build -f docker-base-images/node-base.Dockerfile -t multiservice/node-base:latest docker-base-images/ || {
    echo "❌ Failed to build node base image"
    exit 1
}

echo "Building Nginx base image..."
docker build -f docker-base-images/nginx-base.Dockerfile -t multiservice/nginx-base:latest docker-base-images/ || {
    echo "❌ Failed to build nginx base image"
    exit 1
}

echo "✅ Custom base images built successfully"

# Step 2: Build application services
echo ""
echo "📦 Step 2: Building application services..."
echo "Building API service..."
docker build -t multiservice/api-service:latest ./api-service || {
    echo "❌ Failed to build API service"
    exit 1
}

echo "Building Web application..."
docker build -t multiservice/web-app:latest ./web-app || {
    echo "❌ Failed to build web application"
    exit 1
}

echo "Building Nginx reverse proxy..."
docker build -t multiservice/nginx:latest ./nginx || {
    echo "❌ Failed to build nginx service"
    exit 1
}

echo "✅ All application services built successfully"

# Step 3: Pull external images
echo ""
echo "📦 Step 3: Pulling external images..."
docker pull mongo:7-jammy
docker pull redis:7-alpine
docker pull alpine:latest

echo ""
echo "🎉 Build completed successfully!"
echo ""
echo "Available images:"
docker images | grep multiservice

echo ""
echo "To start the application:"
echo "  docker-compose up -d"
echo ""
echo "To rebuild and start:"
echo "  docker-compose up --build -d"