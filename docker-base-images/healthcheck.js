#!/usr/bin/env node

// Generic health check utility for Node.js services
const http = require('http');
const process = require('process');

const healthCheckEndpoint = process.env.HEALTH_CHECK_ENDPOINT || '/health';
const port = process.env.PORT || 3000;
const timeout = parseInt(process.env.HEALTH_CHECK_TIMEOUT || '5000');

const options = {
  hostname: 'localhost',
  port: port,
  path: healthCheckEndpoint,
  method: 'GET',
  timeout: timeout
};

const req = http.request(options, (res) => {
  if (res.statusCode === 200) {
    console.log('Health check passed');
    process.exit(0);
  } else {
    console.log(`Health check failed with status: ${res.statusCode}`);
    process.exit(1);
  }
});

req.on('error', (err) => {
  console.log(`Health check failed: ${err.message}`);
  process.exit(1);
});

req.on('timeout', () => {
  console.log('Health check timed out');
  req.destroy();
  process.exit(1);
});

req.end();