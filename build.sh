#!/usr/bin/env bash
set -euo pipefail

IMAGE_NAME="asy-webapp"
USER_UID=1000

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

docker build \
    --build-arg USER_UID="$USER_UID" \
    -t "$IMAGE_NAME" \
    "$SCRIPT_DIR"
