#!/usr/bin/env bash
set -euo pipefail

IMAGE_NAME="asy-webapp"
CONTAINER_NAME="asy-webapp"
HOST_PORT=9527

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

docker rm -f "$CONTAINER_NAME" 2>/dev/null || true

docker run -d \
    --name "$CONTAINER_NAME" \
    --restart always \
    -v "$SCRIPT_DIR/asy_extra_modules:/home/asymptote/.asy:ro" \
    -p "0.0.0.0:$HOST_PORT:80" \
    "$IMAGE_NAME"

echo "asy-webapp running at http://localhost:$HOST_PORT"
