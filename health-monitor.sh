#!/bin/sh

# Health monitoring script for all services
echo "=== Health Check Report - $(date) ==="

# Service endpoints to check
SERVICES="nginx:80/health api-service:3000/health web-app:80/health"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

check_service() {
    local service=$1
    local url="http://$service"
    
    echo -n "Checking $service: "
    
    if curl -sf "$url" > /dev/null 2>&1; then
        echo -e "${GREEN}HEALTHY${NC}"
        return 0
    else
        echo -e "${RED}UNHEALTHY${NC}"
        return 1
    fi
}

# Check all services
healthy_count=0
total_count=0

for service in $SERVICES; do
    total_count=$((total_count + 1))
    if check_service "$service"; then
        healthy_count=$((healthy_count + 1))
    fi
done

# Summary
echo ""
echo "Summary: $healthy_count/$total_count services healthy"

if [ "$healthy_count" -eq "$total_count" ]; then
    echo -e "${GREEN}All services are running normally${NC}"
    exit 0
elif [ "$healthy_count" -gt 0 ]; then
    echo -e "${YELLOW}Some services are experiencing issues${NC}"
    exit 1
else
    echo -e "${RED}All services are down${NC}"
    exit 2
fi