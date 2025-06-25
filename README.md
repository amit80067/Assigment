# Multi-Service Docker Application

A microservices architecture using Docker Compose with nginx reverse proxy, Go service, and Python Flask service.

##  Quick Start

### Prerequisites
- Docker Desktop installed and running
- macOS/Linux terminal or WSL on Windows

### Setup Instructions

1. **Clone/Navigate to project directory:**
   ```bash
   cd Assignment
   ```

2. **Build and start all services:**
   ```bash
   docker compose up --build -d
   ```

3. **Verify services are running:**
   ```bash
   docker compose ps
   ```

4. **Test the application:**
   ```bash
   # Test via nginx reverse proxy
   curl http://localhost:8080/service1/ping
   curl http://localhost:8080/service2/ping
   
   # Test direct service access
   curl http://localhost:8001/ping
   curl http://localhost:8002/ping
   ```

## Routing & API Endpoints

### Nginx Reverse Proxy (Port 8080)
- **Service 1**: `http://localhost:8080/service1/*` → `http://service_1:8001/*`
- **Service 2**: `http://localhost:8080/service2/*` → `http://service_2:8002/*`

### Available Endpoints

#### Service 1 (Go) - Port 8001
- `GET /` - Service information and available endpoints
- `GET /ping` - Health check: `{"service":"1","status":"ok"}`
- `GET /hello` - Greeting: `{"message":"Hello from Service 1"}`
- `GET /health` - Detailed health status

#### Service 2 (Python Flask) - Port 8002
- `GET /` - Service information and available endpoints  
- `GET /ping` - Health check: `{"service":"2","status":"ok"}`
- `GET /hello` - Greeting: `{"message":"Hello from Service 2"}`
- `GET /health` - Detailed health status

##  Docker Configuration

### Network Setup
- **Network Type**: Bridge Network (Docker default)
- **Container Linking**: Using `links` for service discovery
- **Port Mapping**: Host ports mapped to container ports

### Services
- **nginx**: Alpine-based reverse proxy with custom configuration
- **service_1**: Go 1.20 Alpine with health checks
- **service_2**: Python 3.13 with Flask and health checks

##  Bonus Features Implemented

###  1. Health Checks
- **Built-in Docker Health Checks** for both services
- **Custom Health Endpoints** (`/health`) with detailed status
- **Automated Health Monitoring** with 10s intervals, 3 retries

###  2. Logging Clarity
- **Nginx Access Logs** with custom format showing timestamp and URI
- **Service Logs** with clear startup messages and request tracking
- **Structured Logging** for easy debugging

###  3. Clean & Modular Docker Setup
- **Multi-stage builds** where applicable
- **Optimized Dockerfiles** with minimal base images (Alpine)
- **Proper dependency management** (go.mod, requirements.txt)
- **Container linking** for service discovery

###  4. Automated Test Script
Run the test script to verify all endpoints:

```bash
# Make test script executable and run
chmod +x test-services.sh
./test-services.sh
```

##  Testing

### Manual Testing
```bash
# Test all endpoints
curl -s http://localhost:8080/service1/ping | jq
curl -s http://localhost:8080/service2/ping | jq  
curl -s http://localhost:8080/service1/hello | jq
curl -s http://localhost:8080/service2/hello | jq

# Test health endpoints
curl -s http://localhost:8001/health | jq
curl -s http://localhost:8002/health | jq

# Test direct service access
curl -s http://localhost:8001/ping | jq
curl -s http://localhost:8002/ping | jq
```

### Automated Testing
```bash
./test-services.sh
```

##  Monitoring

### View Logs
```bash
# All services
docker compose logs -f

# Specific service
docker compose logs -f nginx
docker compose logs -f service_1
docker compose logs -f service_2
```

### Health Status
```bash
# Check container health
docker compose ps

# Inspect health check details
docker inspect assignment-service_1-1 | jq '.[].State.Health'
docker inspect assignment-service_2-1 | jq '.[].State.Health'
```

##  Development

### Rebuild Services
```bash
# Rebuild specific service
docker compose up --build service_1 -d

# Rebuild all
docker compose up --build -d
```

### Debug Mode
```bash
# Run with logs attached
docker compose up --build

# Shell into container
docker exec -it assignment-service_1-1 sh
docker exec -it assignment-service_2-1 bash
```

##  Cleanup

```bash
# Stop and remove containers
docker compose down

# Remove with volumes
docker compose down -v

# Remove images
docker compose down --rmi all
```

##  Configuration Files

- `docker-compose.yml` - Multi-service orchestration
- `nginx/nginx.conf` - Reverse proxy configuration  
- `service_1/Dockerfile` - Go service container
- `service_2/Dockerfile` - Python Flask container
- `service_1/main.go` - Go HTTP server
- `service_2/app.py` - Flask application

##  Troubleshooting

### Common Issues

1. **Port conflicts**: Ensure ports 8080, 8001, 8002 are available
2. **Docker not running**: Start Docker Desktop
3. **Permission denied**: Use `sudo` on Linux or check Docker permissions
4. **Network issues**: Try rebuilding: `docker compose down && docker compose up --build`

### Debug Commands
```bash
# Check port usage
lsof -i :8080
netstat -tlnp | grep :8080

# Check Docker networks
docker network ls
docker network inspect bridge

# Check container status
docker ps -a
docker compose ps
```

##  Performance Features

- **Lightweight containers** using Alpine Linux
- **Efficient networking** with bridge network
- **Health monitoring** for high availability
- **Modular architecture** for easy scaling
- **Clean logging** for debugging and monitoring