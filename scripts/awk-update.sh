#!/bin/bash
set -euo pipefail

brew update
brew upgrade --force-bottle
brew upgrade --cask
brew cleanup
