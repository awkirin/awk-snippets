#!/bin/bash
#
# This script should be run via curl:
#   /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/awkirin/awk-snippets/HEAD/init-awk-snippets.sh)"
#
# repo: https://github.com/awkirin/awk-snippets

awk_snippets() {
    local path="$1"
    sudo /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/awkirin/awk-snippets/HEAD/bin/$path)"
}