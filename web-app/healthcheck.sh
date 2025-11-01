#!/bin/sh

# Health check script for web application
curl -f http://localhost/health || exit 1