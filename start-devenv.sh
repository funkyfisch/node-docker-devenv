#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

USER="$(whoami)"
DEV_PORT=${DEV_PORT:-4000}
HOT_RELOAD_PORT=${HOT_RELOAD_PORT:-35729}

docker run \
    --rm \
    -it \
    -e USER=${USER} \
    -h node-docker-devenv \
    -p ${DEV_PORT}:8080 \
    -p ${HOT_RELOAD_PORT}:${HOT_RELOAD_PORT} \
    -v "$(pwd)":/mnt/workspace \
    -v /etc/passwd:/etc/passwd:ro \
    -v /etc/group:/etc/group:ro \
    -v /etc/timezone:/etc/timezone:ro \
    -v ${HOME}:/home/${USER}/ \
    -w /mnt/workspace \
    nodejs-docker-devenv:latest \
    bash
