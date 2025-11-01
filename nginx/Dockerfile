# Use custom Nginx base image
FROM multiservice/nginx-base:latest

# Remove default configuration (if it exists)
RUN rm -f /etc/nginx/conf.d/default.conf

# Copy custom nginx configuration
COPY nginx.conf /etc/nginx/nginx.conf
COPY default.conf /etc/nginx/conf.d/default.conf

# Create custom error pages
COPY 50x.html /usr/share/nginx/html/50x.html

# Create log directory and set permissions (skip if already exist)
RUN mkdir -p /var/log/nginx || true

# Create cache directories
RUN mkdir -p /var/cache/nginx/client_temp && \
    mkdir -p /var/cache/nginx/proxy_temp && \
    mkdir -p /var/cache/nginx/fastcgi_temp && \
    mkdir -p /var/cache/nginx/uwsgi_temp && \
    mkdir -p /var/cache/nginx/scgi_temp

# Add health check script
COPY --chmod=755 healthcheck.sh /usr/local/bin/healthcheck.sh

# Expose ports
EXPOSE 80

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
    CMD ["/usr/local/bin/healthcheck.sh"]

# Start nginx
CMD ["nginx", "-g", "daemon off;"]