# Logs directory - contains application and service logs
# These directories are created by the Docker Compose setup

## Directory Structure
- `nginx/` - Nginx access and error logs
- `app/` - Application logs from web-app and api-service
- `mongodb/` - MongoDB database logs
- `redis/` - Redis cache logs

## Log Rotation
Logs are automatically rotated by the logrotate service:
- Daily rotation for nginx logs (kept for 30 days)
- Daily rotation for application logs (kept for 14 days)
- Compression enabled to save disk space

## Accessing Logs
```bash
# View all logs
docker-compose logs -f

# View specific service logs
docker-compose logs -f nginx
docker-compose logs -f api-service
docker-compose logs -f web-app

# View log files directly
tail -f logs/nginx/access.log
tail -f logs/nginx/error.log
```

## Log Monitoring
The health-monitor service continuously checks service status and logs results.
Use `./health-monitor.sh` to run manual health checks.