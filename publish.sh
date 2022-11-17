#!/usr/bin/env bash

set -x

name="$(head -1 container-name)"
docker_username="$(head -1 username)"

docker login
docker buildx build -t "${docker_username}/${name}:latest" --platform linux/amd64,linux/arm64,linux/arm/v7 --push .

set +x
