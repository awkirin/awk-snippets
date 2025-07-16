#!/bin/bash
#
# This script should be run via curl:
#   sudo /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/awkirin/awk-scripts/main/osx/tor-bridges.sh)"
#
# repo: https://github.com/awkirin/awk-scripts

TORRC="/usr/local/etc/tor/torrc"

sudo sed -i '' '/^Bridge/d' "${TORRC}"

