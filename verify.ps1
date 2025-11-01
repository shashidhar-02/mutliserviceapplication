# PowerShell verification script for Multi-Service Application
Write-Host "🔍 Multi-Service Application Requirements Verification" -ForegroundColor Cyan
Write-Host "======================================================" -ForegroundColor Cyan

# Check 1: Verify all required components exist
Write-Host ""
Write-Host "📋 Checking Required Components..." -ForegroundColor Yellow

$components = @(
    "web-app\Dockerfile",
    "web-app\src\App.js",
    "web-app\package.json",
    "api-service\Dockerfile",
    "api-service\server.js", 
    "api-service\package.json",
    "nginx\Dockerfile",
    "nginx\nginx.conf",
    "nginx\default.conf",
    "docker-compose.yml",
    "docker-base-images\node-base.Dockerfile",
    "docker-base-images\nginx-base.Dockerfile",
    "secrets\mongodb_uri.txt",
    "secrets\redis_url.txt",
    "secrets\session_secret.txt",
    "logrotate.conf",
    "health-monitor.sh"
)

$missing_components = 0
foreach ($component in $components) {
    if (Test-Path $component) {
        Write-Host "✅ $component" -ForegroundColor Green
    } else {
        Write-Host "❌ $component (MISSING)" -ForegroundColor Red
        $missing_components++
    }
}

if ($missing_components -eq 0) {
    Write-Host "✅ All required components present" -ForegroundColor Green
} else {
    Write-Host "❌ $missing_components components missing" -ForegroundColor Red
    exit 1
}

# Check 2: Verify Docker requirements
Write-Host ""
Write-Host "🐳 Checking Docker Requirements..." -ForegroundColor Yellow

# Multi-stage build check
if ((Get-Content "web-app\Dockerfile") -match "FROM.*AS.*") {
    Write-Host "✅ Multi-stage build implemented in web-app" -ForegroundColor Green
} else {
    Write-Host "❌ Multi-stage build missing in web-app" -ForegroundColor Red
    exit 1
}

# Custom base image usage check
if ((Get-Content "api-service\Dockerfile") -match "multiservice/node-base") {
    Write-Host "✅ Custom Node.js base image used in API service" -ForegroundColor Green
} else {
    Write-Host "❌ Custom Node.js base image not used in API service" -ForegroundColor Red
    exit 1
}

if ((Get-Content "nginx\Dockerfile") -match "multiservice/nginx-base") {
    Write-Host "✅ Custom Nginx base image used in nginx service" -ForegroundColor Green
} else {
    Write-Host "❌ Custom Nginx base image not used in nginx service" -ForegroundColor Red
    exit 1
}

# Docker Compose features check
$composeContent = Get-Content "docker-compose.yml" -Raw

if ($composeContent -match "secrets:") {
    Write-Host "✅ Docker secrets implemented" -ForegroundColor Green
} else {
    Write-Host "❌ Docker secrets missing" -ForegroundColor Red
    exit 1
}

if ($composeContent -match "networks:") {
    Write-Host "✅ Docker networks configured" -ForegroundColor Green
} else {
    Write-Host "❌ Docker networks missing" -ForegroundColor Red
    exit 1
}

if ($composeContent -match "volumes:") {
    Write-Host "✅ Docker volumes configured" -ForegroundColor Green
} else {
    Write-Host "❌ Docker volumes missing" -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "🎉 All Requirements Verification Passed!" -ForegroundColor Green
Write-Host "======================================" -ForegroundColor Green
Write-Host ""
Write-Host "✅ Ready for deployment!" -ForegroundColor Green