# Use Node.js base image (simplified for now)
FROM node:18-alpine

# Install security updates and tools
RUN apk update && apk upgrade && \
    apk add --no-cache \
    dumb-init \
    curl \
    && rm -rf /var/cache/apk/*

# Create non-root user
RUN addgroup -g 1001 -S nodejs && \
    adduser -S nodejs -u 1001 -g nodejs

# Create app directory
WORKDIR /app

# Copy package files
COPY package*.json ./

# Install dependencies (as root, then fix permissions)
RUN npm install --omit=dev && \
    npm cache clean --force && \
    mkdir -p logs

# Copy application code
COPY . .

# Set ownership (do this after copying everything)
RUN chown -R nodejs:nodejs /app

# Switch to non-root user (already defined in base image)
USER nodejs

# Expose port
EXPOSE 3000

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=15s --retries=3 \
    CMD curl -f http://localhost:3000/health || exit 1

# Use dumb-init for proper signal handling
ENTRYPOINT ["/usr/bin/dumb-init", "--"]

# Start the application
CMD ["node", "server.js"]