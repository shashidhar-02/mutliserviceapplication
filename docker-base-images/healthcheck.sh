#!/bin/sh

# Health check script for Nginx
curl -f http://localhost/health || exit 1