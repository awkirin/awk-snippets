#!/bin/bash

OS=$(uname -s)
APP_DIR=$(dirname $PWD)
ln -sf "${APP_DIR}/artisan" ~/bin/awkirin

echo $OS

if [[ "$OS" == "Darwin"* ]]; then
  source ./install-osx-contextmenu.sh
fi

if [[ "$OS" == "Linux"* ]]; then
  echo 123123
fi