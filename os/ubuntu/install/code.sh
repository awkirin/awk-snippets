#!/bin/bash

# https://code.visualstudio.com/docs/setup/linux

set -eufo pipefail

# Update system first
sudo apt update

# Install dependencies
sudo apt install wget gpg apt-transport-https -y

# Install Microsoft GPG key
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
sudo install -D -o root -g root -m 644 microsoft.gpg /usr/share/keyrings/microsoft.gpg
rm -f microsoft.gpg

# Add repository
# sudo tee "/etc/apt/sources.list.d/vscode.sources" > /dev/null <<EOF
Types: deb
URIs: https://packages.microsoft.com/repos/code
Suites: stable
Components: main
Architectures: amd64,arm64,armhf
Signed-By: /usr/share/keyrings/microsoft.gpg
EOF

# Install VS Code
sudo apt install apt-transport-https -y
sudo apt update
sudo apt install code -y