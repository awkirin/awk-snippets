#!/bin/bash
#
# This script should be run via curl:
#   /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/awkirin/awk-snippets/main/regru/sites-composer-updage.sh)"

set -euo pipefail

export HOME="${HOME:-$(eval echo ~)}"
export PATH="${HOME}/bin:${PATH}"
export COMPOSER_HOME="${COMPOSER_HOME:-"${HOME}/.config/composer"}"

WWW_DIR="${WWW_DIR:-"${HOME}/www"}"

for SITE_DIR in "$WWW_DIR"/*/; do
    if [[ ! -L "${SITE_DIR}" ]] && [[ -f "${SITE_DIR}/composer.json" ]]; then
        echo "-------------------------------------------------"
        echo "dir: ${SITE_DIR#${HOME}}"
        echo ""
        composer update -d "${SITE_DIR}" --no-dev --optimize-autoloader --classmap-authoritative --no-interaction
        echo "-------------------------------------------------"
        echo ""
    fi
done
