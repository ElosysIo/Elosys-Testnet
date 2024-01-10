#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/../.."

cat .gitignore - > .dockerignore <<EOF
# do not send the .git directory to the Docker daemon to make builds faster
.git
EOF

echo "Building Docker Image"

export DOCKER_BUILDKIT=1

docker build . \
    --progress plain \
    --tag elosys:latest \
    --file elosys-cli/Dockerfile

docker run \
    --interactive \
    --rm \
    elosys:latest --version
