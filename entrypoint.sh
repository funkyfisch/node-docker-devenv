#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

runuser "${USER}"
# shellcheck source=/dev/null
source "/home/${USER}/.bashrc"

exec "${@}"
