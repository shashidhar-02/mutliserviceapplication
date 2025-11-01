#!/bin/sh

# Health check script for Nginx reverse proxy
curl -f http://localhost/health || exit 1