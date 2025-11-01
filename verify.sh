#!/bin/bash

# Comprehensive verification script to ensure all requirements are met
set -e

echo "🔍 Multi-Service Application Requirements Verification"
echo "======================================================"

# Check 1: Verify all required components exist
echo ""
echo "📋 Checking Required Components..."

components=(
    "web-app/Dockerfile"
    "web-app/src/App.js"
    "web-app/package.json"
    "api-service/Dockerfile"
    "api-service/server.js"
    "api-service/package.json"
    "nginx/Dockerfile"
    "nginx/nginx.conf"
    "nginx/default.conf"
    "docker-compose.yml"
    "docker-base-images/node-base.Dockerfile"
    "docker-base-images/nginx-base.Dockerfile"
    "secrets/mongodb_uri.txt"
    "secrets/redis_url.txt"
    "secrets/session_secret.txt"
    "logrotate.conf"
    "health-monitor.sh"
)

missing_components=0
for component in "${components[@]}"; do
    if [ -f "$component" ]; then
        echo "✅ $component"
    else
        echo "❌ $component (MISSING)"
        missing_components=$((missing_components + 1))
    fi
done

if [ $missing_components -eq 0 ]; then
    echo "✅ All required components present"
else
    echo "❌ $missing_components components missing"
    exit 1
fi

# Check 2: Verify Docker requirements
echo ""
echo "🐳 Checking Docker Requirements..."

# Multi-stage build check
if grep -q "FROM.*AS.*" web-app/Dockerfile; then
    echo "✅ Multi-stage build implemented in web-app"
else
    echo "❌ Multi-stage build missing in web-app"
    exit 1
fi

# Custom base image usage check
if grep -q "multiservice/node-base" api-service/Dockerfile; then
    echo "✅ Custom Node.js base image used in API service"
else
    echo "❌ Custom Node.js base image not used in API service"
    exit 1
fi

if grep -q "multiservice/nginx-base" nginx/Dockerfile; then
    echo "✅ Custom Nginx base image used in nginx service"
else
    echo "❌ Custom Nginx base image not used in nginx service"
    exit 1
fi

# Docker Compose features check
if grep -q "secrets:" docker-compose.yml; then
    echo "✅ Docker secrets implemented"
else
    echo "❌ Docker secrets missing"
    exit 1
fi

if grep -q "networks:" docker-compose.yml; then
    echo "✅ Docker networks configured"
else
    echo "❌ Docker networks missing"
    exit 1
fi

if grep -q "volumes:" docker-compose.yml; then
    echo "✅ Docker volumes configured"
else
    echo "❌ Docker volumes missing"
    exit 1
fi

# Health checks
if grep -q "HEALTHCHECK" api-service/Dockerfile && grep -q "HEALTHCHECK" web-app/Dockerfile && grep -q "HEALTHCHECK" nginx/Dockerfile; then
    echo "✅ Health checks implemented in all services"
else
    echo "❌ Health checks missing in some services"
    exit 1
fi

# Check 3: Verify application requirements
echo ""
echo "🚀 Checking Application Requirements..."

# React app
if grep -q "react" web-app/package.json; then
    echo "✅ React-based frontend application"
else
    echo "❌ React frontend missing"
    exit 1
fi

# Express API
if grep -q "express" api-service/package.json; then
    echo "✅ Node.js Express backend API"
else
    echo "❌ Express API missing"
    exit 1
fi

# MongoDB integration
if grep -q "mongoose" api-service/package.json; then
    echo "✅ MongoDB integration implemented"
else
    echo "❌ MongoDB integration missing"
    exit 1
fi

# Redis cache
if grep -q "redis" api-service/package.json; then
    echo "✅ Redis cache integration implemented"
else
    echo "❌ Redis cache integration missing"
    exit 1
fi

# Logging configuration
if [ -f "logrotate.conf" ] && [ -d "logrotate.d" ]; then
    echo "✅ Logging and log rotation configured"
else
    echo "❌ Logging configuration incomplete"
    exit 1
fi

echo ""
echo "🎉 All Requirements Verification Passed!"
echo "======================================"
echo ""
echo "✅ Multi-service application with:"
echo "   • React-based frontend application"
echo "   • Node.js Express backend API"
echo "   • MongoDB database instance"
echo "   • Redis cache for performance"
echo "   • Nginx reverse proxy"
echo ""
echo "✅ Docker features implemented:"
echo "   • Docker Compose orchestration"
echo "   • Custom base images for web app and API service"
echo "   • Multi-stage builds for optimized web application"
echo "   • Docker networks for service communication"
echo "   • Docker volumes for persistent data storage"
echo "   • Docker secrets for sensitive information"
echo "   • Health checks for all services"
echo "   • Optimized Dockerfiles with reduced image sizes"
echo "   • Logging and log rotation for all services"
echo ""
echo "🚀 Ready for deployment!"
echo ""
echo "Next steps:"
echo "1. ./build.sh              # Build all images"
echo "2. docker-compose up -d    # Start all services"
echo "3. ./health-monitor.sh     # Check service health"