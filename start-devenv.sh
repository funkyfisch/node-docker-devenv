#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

USER="$(whoami)"
DEV_PORT=${DEV_PORT:-4000}
HOT_RELOAD_PORT=${HOT_RELOAD_PORT:-35729}

docker run \
    --interactive \
    --env USER=${USER} \
    --hostname node-docker-devenv \
    --name node-docker-devenv \
    --publish ${DEV_PORT}:8080 \
    --publish ${HOT_RELOAD_PORT}:${HOT_RELOAD_PORT} \
    --rm \
    --tty \
    --volume "$(pwd)":/mnt/workspace \
    --volume /etc/passwd:/etc/passwd:ro \
    --volume /etc/group:/etc/group:ro \
    --volume /etc/timezone:/etc/timezone:ro \
    --volume ${HOME}:/home/${USER}/ \
    --workdir /mnt/workspace \
    node-docker-devenv:latest \
    bash
