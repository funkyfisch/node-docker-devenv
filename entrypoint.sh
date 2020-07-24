#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

runuser $USER
source /home/$USER/.bashrc

exec $@
