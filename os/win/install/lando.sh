#!/bin/bash

curl -fsSL https://get.lando.dev/setup-lando.sh -o tmp-setup-lando.sh
chmod +x ./tmp-setup-lando.sh
bash ./tmp-setup-lando.sh -y
rm ./tmp-setup-lando.sh

# OSX
# security add-trusted-cert -r trustRoot -k ~/Library/Keychains/login.keychain-db ~/.lando/certs/LandoCA.crt
