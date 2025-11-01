# Custom Node.js base image with security and optimization
FROM node:18-alpine

# Install security updates and useful tools
RUN apk update && apk upgrade && \
    apk add --no-cache \
    dumb-init \
    curl \
    && rm -rf /var/cache/apk/*

# Create non-root user for security
RUN addgroup -g 1001 -S nodejs && \
    adduser -S nodejs -u 1001

# Set up working directory
WORKDIR /app

# Install global packages with specific versions for security
RUN npm cache clean --force

# Switch to non-root user
USER nodejs

# Add health check utility
COPY --chown=nodejs:nodejs healthcheck.js /usr/local/bin/healthcheck.js

# Default command
ENTRYPOINT ["/usr/bin/dumb-init", "--"]
CMD ["node"]