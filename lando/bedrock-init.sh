#!/bin/bash
#
# This script should be run via curl:
#   /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/awkirin/awk-scripts/main/lando/bedrock-init.sh)"
#
# repo: https://github.com/awkirin/awk-scripts

set -euo pipefail


APP_NAME="${APP_NAME:-awkirin}"

THEME_DIR_NAME="${THEME_DIR_NAME:-sage}"
THEME_DIR="${THEME_DIR:-web/app/themes/sage}"

ADMIN_USER="${ADMIN_USER:-admin}"
ADMIN_PASSWORD="${ADMIN_PASSWORD:-admin}"
ADMIN_EMAIL="${ADMIN_EMAIL:-test@test.ru}"


if [[ ! -f ".lando.yml" ]]; then
    cat > .lando.yml <<EOL
name: ${APP_NAME}
recipe: wordpress
config:
  webroot: "web"
  php: "8.2"
  composer_version: "2.8.10"
  via: nginx
  xdebug: false
services:
  appserver:
    scanner: false
    healthcheck: false
  appserver_nginx:
    scanner: false
    healthcheck: false
  database:
    scanner: false
    healthcheck: false
  node:
    type: node:22
    scanner: false
    healthcheck: false
  pma:
    type: phpmyadmin
    scanner: false
    healthcheck: false

tooling:
  yarn:
    service: node

proxy:
  appserver_nginx:
    - "${APP_NAME}.lndo.site"
  pma:
    - "${APP_NAME}.lndo.site/pma"
  node:
    - "localhost:5173"


EOL

    lando rebuild -y
fi

if [[ ! -f "composer.json" ]]; then

    composer create-project roots/bedrock /tmp/bedrock
    composer remove wpackagist-theme/twentytwentyfive
    composer require \
        wpackagist-plugin/wp-rocket \
        wpackagist-plugin/advanced-custom-fields-pro \
        wpackagist-plugin/acf-extended-pro \
        wpackagist-plugin/ar-contactus \
        wpackagist-plugin/wordpress-seo \
        wpackagist-plugin/wordpress-seo-premium

    lando exec appserver -- bash -c 'cp -a /tmp/bedrock/. . && rm -rf /tmp/bedrock'

    lando exec appserver -- cp ".env.example" ".env"
    lando exec appserver -- perl -i -pe "s|DB_NAME='database_name'|DB_NAME='wordpress'|g" ".env"
    lando exec appserver -- perl -i -pe "s|DB_USER='database_user'|DB_USER='wordpress'|g" ".env"
    lando exec appserver -- perl -i -pe "s|DB_PASSWORD='database_password'|DB_PASSWORD='wordpress'|g" ".env"
    lando exec appserver -- perl -i -pe "s|# DB_HOST='localhost'|DB_HOST='database'|g" ".env"
#     lando exec appserver -- perl -i -pe "s|# DB_PREFIX='wp_'|DB_PREFIX='wp_'|g" ".env"
    lando exec appserver -- perl -i -pe "s|WP_HOME='http://example.com'|WP_HOME='https://${APP_NAME}.lndo.site'|g" ".env"


    lando wp core install --url="${APP_NAME}.lndo.site" --title="${APP_NAME}" --admin_user="${ADMIN_USER}" --admin_password="${ADMIN_PASSWORD}" --admin_email="${ADMIN_EMAIL}"
fi

if [[ ! -d "${THEME_DIR}" ]]; then

    composer create-project roots/sage "${THEME_DIR}"

    echo "APP_URL='https://${APP_NAME}.lndo.site'" > "${THEME_DIR}/.env"


    lando yarn --cwd "${THEME_DIR}" install
    lando yarn --cwd "${THEME_DIR}" build

    rm -rf "${THEME_DIR}/node_modules"
    yarn --cwd "${THEME_DIR}" install

    lando wp theme activate "${THEME_DIR_NAME}"
fi

if [[ ! -d "${THEME_DIR}/inc" ]]; then
    mkdir "${THEME_DIR}/inc"
    mkdir "${THEME_DIR}/inc/blocks"
    mkdir "${THEME_DIR}/inc/fields"
    mkdir "${THEME_DIR}/inc/field-groups"
    mkdir "${THEME_DIR}/inc/shortcodes"
    mkdir "${THEME_DIR}/inc/option-pages"
    cat > "${THEME_DIR}/inc/_include.php" <<'EOL'
<?php

foreach ([ 'blocks', 'field-groups', 'fields', 'option-pages', 'shortcodes',] as $dir) {
    $iterator = new \RecursiveIteratorIterator(
        new \RecursiveDirectoryIterator(__DIR__ . "/$dir", FilesystemIterator::SKIP_DOTS)
    );
    foreach ($iterator as $file) {
        if (!$file->isFile()) {
            continue;
        }
        require_once $file->getRealPath();
    }
}
EOL

echo "" >> "${THEME_DIR}/functions.php"
echo "require_once __DIR__ . '/inc/_include.php';" >> "${THEME_DIR}/functions.php"

fi
