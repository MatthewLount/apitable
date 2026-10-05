#!/bin/bash
set -e

echo "🔨 Building APITable Docker images for development..."

# Build timestamp for cache busting
BUILD_TIME=$(date +%s)
export IMAGE_TAG="dev-${BUILD_TIME}"

# Set registry to local for development
export IMAGE_REGISTRY="localhost/apitable-"

echo "📦 Building images with tag: ${IMAGE_TAG}"

# Build all images using docker buildx bake
docker buildx bake \
  --set "*.platform=linux/amd64" \
  --set "backend-server.tags=${IMAGE_REGISTRY}backend-server:${IMAGE_TAG},${IMAGE_REGISTRY}backend-server:dev-latest" \
  --set "room-server.tags=${IMAGE_REGISTRY}room-server:${IMAGE_TAG},${IMAGE_REGISTRY}room-server:dev-latest" \
  --set "web-server.tags=${IMAGE_REGISTRY}web-server:${IMAGE_TAG},${IMAGE_REGISTRY}web-server:dev-latest" \
  --set "init-db.tags=${IMAGE_REGISTRY}init-db:${IMAGE_TAG},${IMAGE_REGISTRY}init-db:dev-latest" \
  --set "openresty.tags=${IMAGE_REGISTRY}openresty:${IMAGE_TAG},${IMAGE_REGISTRY}openresty:dev-latest" \
  --load

echo "✅ Build complete! Images tagged with:"
echo "   - ${IMAGE_TAG} (timestamped)"
echo "   - dev-latest (always latest dev build)"

echo ""
echo "🚀 To start the development environment:"
echo "   docker-compose -f docker-compose.dev.yml up -d"
echo ""
echo "🔄 To rebuild and restart:"
echo "   ./scripts/build-dev-images.sh && docker-compose -f docker-compose.dev.yml up -d --force-recreate"