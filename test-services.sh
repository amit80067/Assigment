#!/bin/bash

# Simple test script for multi-service application
# Tests basic endpoints to make sure everything works

echo "Testing Multi-Service Application..."
echo "===================================="

# Check if services are running
echo "Checking if Docker services are up..."
if ! docker compose ps | grep -q "Up"; then
    echo "ERROR: Services not running. Start with: docker compose up -d"
    exit 1
fi
echo "Services are running ✓"
echo ""

# Test function
test_url() {
    local url=$1
    local name=$2
    
    echo -n "Testing $name... "
    response=$(curl -s "$url" 2>/dev/null)
    
    if [ $? -eq 0 ] && [ -n "$response" ]; then
        echo "OK"
        return 0
    else
        echo "FAILED"
        return 1
    fi
}

# Test endpoints
echo "Testing Nginx reverse proxy:"
test_url "http://localhost:8080/service1/ping" "Service 1 via nginx"
test_url "http://localhost:8080/service2/ping" "Service 2 via nginx"
test_url "http://localhost:8080/service1/hello" "Service 1 hello via nginx"
test_url "http://localhost:8080/service2/hello" "Service 2 hello via nginx"

echo ""
echo "Testing direct service access:"
test_url "http://localhost:8001/ping" "Service 1 direct"
test_url "http://localhost:8002/ping" "Service 2 direct"
test_url "http://localhost:8001/hello" "Service 1 hello direct"
test_url "http://localhost:8002/hello" "Service 2 hello direct"

echo ""
echo "Testing health endpoints:"
test_url "http://localhost:8001/health" "Service 1 health"
test_url "http://localhost:8002/health" "Service 2 health"

echo ""
echo "Quick response check:"
echo "Service 1 ping response:"
curl -s http://localhost:8001/ping | head -1

echo "Service 2 ping response:"
curl -s http://localhost:8002/ping | head -1

echo ""
echo "Docker health status:"
docker compose ps

echo ""
echo "Test complete!"
echo "If you see any FAILED tests above, check the logs with: docker compose logs" 