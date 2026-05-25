# PowerShell script to tag and push Docker images to Docker Hub
# Usage: .\push-to-dockerhub.ps1

$DOCKER_USERNAME = "adityadocker132"
$PROJECT_NAME = "hirely"
$VERSION = "latest"

Write-Host "🔐 Logging into Docker Hub..." -ForegroundColor Cyan
docker login

if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ Docker login failed!" -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "📦 Building images..." -ForegroundColor Cyan
docker-compose build

if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ Build failed!" -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "🏷️  Tagging images..." -ForegroundColor Cyan

# Tag backend image
docker tag esewa-jobapplication-backend:latest ${DOCKER_USERNAME}/${PROJECT_NAME}-backend:${VERSION}
docker tag esewa-jobapplication-backend:latest ${DOCKER_USERNAME}/${PROJECT_NAME}-backend:v1.0

# Tag frontend image
docker tag esewa-jobapplication-frontend:latest ${DOCKER_USERNAME}/${PROJECT_NAME}-frontend:${VERSION}
docker tag esewa-jobapplication-frontend:latest ${DOCKER_USERNAME}/${PROJECT_NAME}-frontend:v1.0

Write-Host "✅ Images tagged successfully!" -ForegroundColor Green

Write-Host ""
Write-Host "⬆️  Pushing backend to Docker Hub..." -ForegroundColor Cyan
docker push ${DOCKER_USERNAME}/${PROJECT_NAME}-backend:${VERSION}
docker push ${DOCKER_USERNAME}/${PROJECT_NAME}-backend:v1.0

if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ Backend push failed!" -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "⬆️  Pushing frontend to Docker Hub..." -ForegroundColor Cyan
docker push ${DOCKER_USERNAME}/${PROJECT_NAME}-frontend:${VERSION}
docker push ${DOCKER_USERNAME}/${PROJECT_NAME}-frontend:v1.0

if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ Frontend push failed!" -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "✅ All images pushed successfully to Docker Hub!" -ForegroundColor Green
Write-Host ""
Write-Host "📋 Your images are now available at:" -ForegroundColor Cyan
Write-Host "   - ${DOCKER_USERNAME}/${PROJECT_NAME}-backend:latest" -ForegroundColor Yellow
Write-Host "   - ${DOCKER_USERNAME}/${PROJECT_NAME}-backend:v1.0" -ForegroundColor Yellow
Write-Host "   - ${DOCKER_USERNAME}/${PROJECT_NAME}-frontend:latest" -ForegroundColor Yellow
Write-Host "   - ${DOCKER_USERNAME}/${PROJECT_NAME}-frontend:v1.0" -ForegroundColor Yellow
Write-Host ""
Write-Host "🌐 View on Docker Hub:" -ForegroundColor Cyan
Write-Host "   - https://hub.docker.com/r/${DOCKER_USERNAME}/${PROJECT_NAME}-backend" -ForegroundColor Blue
Write-Host "   - https://hub.docker.com/r/${DOCKER_USERNAME}/${PROJECT_NAME}-frontend" -ForegroundColor Blue
