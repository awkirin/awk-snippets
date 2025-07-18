#!/bin/bash
#
# This script should be run via curl:
#   sudo apt -y update && /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/awkirin/awk-scripts/main/install-docker-engine.sh)"
#
# repo: https://github.com/awkirin/awk-scripts

sudo useradd -m -s /bin/bash dev
echo "dev:dev" | sudo chpasswd
sudo usermod -aG sudo dev
echo "dev ALL=(ALL) NOPASSWD:ALL" | sudo tee /etc/sudoers.d/dev