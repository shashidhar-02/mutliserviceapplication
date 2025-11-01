# Multi-Service Docker Application

A comprehensive multi-service application demonstrating advanced Docker features including custom base images, multi-stage builds, Docker secrets, networks, volumes, health checks, and logging.

## 🏗️ Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                    Load Balancer/Reverse Proxy              │
│                         (Nginx)                            │
└─────────────────────┬───────────────────────────────────────┘
                      │
        ┌─────────────┼─────────────┐
        │             │             │
        ▼             ▼             ▼
┌──────────────┐ ┌──────────────┐ ┌──────────────┐
│  Web App     │ │   API        │ │   Health     │
│  (React)     │ │  (Express)   │ │   Monitor    │
│              │ │              │ │              │
└──────────────┘ └──────┬───────┘ └──────────────┘
                        │
        ┌───────────────┼───────────────┐
        │               │               │
        ▼               ▼               ▼
┌──────────────┐ ┌──────────────┐ ┌──────────────┐
│   MongoDB    │ │    Redis     │ │  Log Rotate  │
│  (Database)  │ │   (Cache)    │ │   Service    │
└──────────────┘ └──────────────┘ └──────────────┘
```

## 🚀 Features Implemented

### Docker Advanced Features
- ✅ **Multi-stage builds** - Optimized React application build
- ✅ **Custom base images** - Secure Node.js and Nginx base images
- ✅ **Docker Compose** - Complete orchestration with dependencies
- ✅ **Docker networks** - Isolated frontend/backend communication
- ✅ **Docker volumes** - Persistent data storage
- ✅ **Docker secrets** - Secure credential management
- ✅ **Health checks** - Application and infrastructure monitoring
- ✅ **Logging & Log rotation** - Centralized log management

### Application Stack
- **Frontend**: React 18 with modern hooks and responsive design
- **Backend**: Express.js with MongoDB and Redis integration
- **Database**: MongoDB with initialization scripts and indexes
- **Cache**: Redis with memory optimization and persistence
- **Reverse Proxy**: Nginx with load balancing and security headers
- **Monitoring**: Health check dashboard and automated monitoring

### Security Features
- Non-root user containers
- Security headers (OWASP recommended)
- Rate limiting and connection limits
- Network isolation between services
- Secrets management for sensitive data
- Input validation and sanitization

## 📁 Project Structure

```
multiserviceapplication/
├── web-app/                    # React frontend application
│   ├── src/                   # React source code
│   ├── public/                # Static assets
│   ├── Dockerfile             # Multi-stage build config
│   ├── nginx.conf             # Frontend nginx config
│   └── package.json           # Dependencies
├── api-service/               # Express.js backend API
│   ├── server.js             # Main application file
│   ├── Dockerfile            # API container config
│   ├── package.json          # Node.js dependencies
│   └── .env.example          # Environment variables template
├── nginx/                     # Reverse proxy configuration
│   ├── nginx.conf            # Main nginx configuration
│   ├── default.conf          # Server block configuration
│   ├── Dockerfile            # Nginx container config
│   └── 50x.html              # Custom error pages
├── docker-base-images/        # Custom base Docker images
│   ├── node-base.Dockerfile  # Secure Node.js base
│   ├── nginx-base.Dockerfile # Secure Nginx base
│   └── healthcheck.js        # Health check utility
├── secrets/                   # Docker secrets (not in production!)
│   ├── mongodb_uri.txt       # Database connection string
│   ├── redis_url.txt         # Cache connection string
│   └── session_secret.txt    # Session encryption key
├── logs/                      # Log storage directory
├── logrotate.conf            # Log rotation configuration
├── logrotate.d/              # Service-specific log configs
├── docker-compose.yml        # Complete orchestration
├── init-mongo.js             # MongoDB initialization
└── health-monitor.sh         # Health monitoring script
```

## 🛠️ Prerequisites

- Docker Engine 20.10+
- Docker Compose 2.0+
- 4GB+ available RAM
- 10GB+ available disk space

## 🚀 Quick Start

### 1. Clone and Setup

```bash
# Clone the repository
git clone <repository-url>
cd multiserviceapplication

# Make scripts executable (Linux/Mac)
chmod +x health-monitor.sh
chmod +x nginx/healthcheck.sh
chmod +x web-app/healthcheck.sh
```

### 2. Build and Run

```bash
# First, verify all requirements are met
./verify.sh

# Build custom base images and application services
./build.sh

# Start all services with proper dependency order
docker-compose up -d

# Check service status
docker-compose ps

# View logs
docker-compose logs -f
```

**Alternative: One-command deployment**
```bash
# Build custom base images first, then start services
make build && docker-compose up -d
```

### 3. Access Applications

- **Main Application**: http://localhost
- **API Documentation**: http://localhost/api
- **Health Check**: http://localhost/health
- **Direct API Access**: http://localhost:3000
- **Direct Frontend**: http://localhost:3001

## 🔧 Configuration

### Environment Variables

The application uses Docker secrets for sensitive data and environment variables for configuration:

#### API Service
```bash
NODE_ENV=production
PORT=3000
MONGODB_URI_FILE=/run/secrets/mongodb_uri
REDIS_URL_FILE=/run/secrets/redis_url
SESSION_SECRET_FILE=/run/secrets/session_secret
```

#### Web Application
```bash
REACT_APP_API_URL=/api
```

### Secrets Management

Secrets are stored in the `secrets/` directory (for development only). In production, use:

```bash
# Create secrets in Docker Swarm
echo "mongodb://user:pass@mongodb:27017/mydb" | docker secret create mongodb_uri -
echo "redis://redis:6379" | docker secret create redis_url -
echo "$(openssl rand -base64 32)" | docker secret create session_secret -
```

## 🏗️ Development

### Running in Development Mode

```bash
# Start databases only
docker-compose up mongodb redis -d

# Install dependencies for local development
cd api-service && npm install
cd ../web-app && npm install

# Run services locally
cd api-service && npm run dev
cd ../web-app && npm start
```

### Building Custom Base Images

```bash
# Build Node.js base image
docker build -f docker-base-images/node-base.Dockerfile -t custom-node-base docker-base-images/

# Build Nginx base image
docker build -f docker-base-images/nginx-base.Dockerfile -t custom-nginx-base docker-base-images/
```

## 📊 Monitoring and Maintenance

### Health Checks

All services include comprehensive health checks:

```bash
# Check all services health
./health-monitor.sh

# Individual service health
curl http://localhost/health
curl http://localhost:3000/health
```

### Log Management

Logs are automatically rotated and managed:

```bash
# View live logs
docker-compose logs -f

# Check log rotation status
docker exec multiservice-logrotate logrotate -d /etc/logrotate.conf

# Manual log rotation
docker exec multiservice-logrotate logrotate -f /etc/logrotate.conf
```

### Performance Monitoring

```bash
# Check container resource usage
docker stats

# View nginx status
curl http://localhost/nginx-status

# MongoDB performance
docker exec multiservice-mongodb mongosh --eval "db.serverStatus()"

# Redis info
docker exec multiservice-redis redis-cli info
```

## 🔒 Security Considerations

### Production Deployment Checklist

- [ ] Change all default passwords and secrets
- [ ] Use external secret management (AWS Secrets Manager, HashiCorp Vault)
- [ ] Enable TLS/HTTPS with proper certificates
- [ ] Configure firewall rules and network policies
- [ ] Set up log aggregation (ELK Stack, Fluentd)
- [ ] Implement monitoring and alerting (Prometheus, Grafana)
- [ ] Regular security updates and vulnerability scanning
- [ ] Database backup and disaster recovery procedures

### Security Features Implemented

- **Container Security**: Non-root users, minimal base images
- **Network Security**: Isolated networks, internal-only database access
- **Application Security**: Rate limiting, input validation, security headers
- **Data Security**: Encrypted secrets, secure session management

## 🛠️ Troubleshooting

### Common Issues

#### Services fail to start
```bash
# Check service logs
docker-compose logs <service-name>

# Restart specific service
docker-compose restart <service-name>

# Rebuild and restart
docker-compose up --build <service-name>
```

#### Database connection issues
```bash
# Check MongoDB logs
docker-compose logs mongodb

# Test MongoDB connection
docker exec multiservice-mongodb mongosh --eval "db.runCommand({ping: 1})"

# Check network connectivity
docker exec multiservice-api ping mongodb
```

#### Cache connection issues
```bash
# Check Redis logs
docker-compose logs redis

# Test Redis connection
docker exec multiservice-redis redis-cli ping

# Clear Redis cache
docker exec multiservice-redis redis-cli flushall
```

### Performance Optimization

#### Resource Limits
```yaml
# Add to docker-compose.yml services
deploy:
  resources:
    limits:
      cpus: '1.0'
      memory: 1G
    reservations:
      cpus: '0.5'
      memory: 512M
```

#### Database Optimization
```bash
# Create additional MongoDB indexes
docker exec multiservice-mongodb mongosh multiservice --eval "
db.items.createIndex({name: 1, timestamp: -1});
db.items.createIndex({userId: 1});
"
```

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- Docker community for excellent documentation
- React and Express.js teams for robust frameworks
- MongoDB and Redis teams for reliable data storage solutions
- Nginx team for powerful reverse proxy capabilities

---

**Built with ❤️ for learning advanced Docker concepts**