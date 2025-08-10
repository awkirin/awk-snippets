#!/bin/bash
#
# This script should be run via curl:
#   APP_NAME=app /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/awkirin/awk-scripts/main/lando/scripts/bedrock-init.sh)"
#
# repo: https://github.com/awkirin/awk-scripts

set -euo pipefail


APP_NAME="${APP_NAME:-app}"

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
    overrides:
      volumes:
        - ~/.composer/auth.json:/var/www/.composer/auth.json
        - ~/.composer/config.json:/var/www/.composer/config.json
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

    # install bedrock
    lando composer create-project roots/bedrock bedrock
    lando exec appserver -- bash -c 'cp -a bedrock/. . && rm -rf bedrock'

    lando composer remove wpackagist-theme/twentytwentyfive

    # extend env.example
    lando exec appserver -- echo "" >> ".env.example"
    lando exec appserver -- echo "DISABLE_WP_CRON='true'" >> ".env.example"

    lando exec appserver -- echo "" >> ".env.example"
    lando exec appserver -- echo "MAIL_HOST=''" >> ".env.example"
    lando exec appserver -- echo "MAIL_PORT=''" >> ".env.example"
    lando exec appserver -- echo "MAIL_USERNAME=''" >> ".env.example"
    lando exec appserver -- echo "MAIL_PASSWORD=''" >> ".env.example"
    lando exec appserver -- echo "MAIL_FROM_ADDRESS=''" >> ".env.example"
    lando exec appserver -- echo "MAIL_FROM_NAME=''" >> ".env.example"
    lando exec appserver -- echo "MAIL_ENCRYPTION=''" >> ".env.example"

    # init .env
    lando wp package install aaemnnosttv/wp-cli-dotenv-command:^2.0 || true
    lando wp dotenv init --template=.env.example --with-salts || true

    lando exec appserver -- perl -i -pe "s|# DB_HOST='localhost'|DB_HOST='database'|g" ".env"
    lando exec appserver -- perl -i -pe "s|# DB_PREFIX='wp_'|DB_PREFIX='wp_'|g" ".env"
    lando exec appserver -- perl -i -pe "s|DB_NAME='database_name'|DB_NAME='wordpress'|g" ".env"
    lando exec appserver -- perl -i -pe "s|DB_USER='database_user'|DB_USER='wordpress'|g" ".env"
    lando exec appserver -- perl -i -pe "s|DB_PASSWORD='database_password'|DB_PASSWORD='wordpress'|g" ".env"
    lando exec appserver -- perl -i -pe "s|WP_HOME='http://example.com'|WP_HOME=''|g" ".env"

    cat > ".htaccess" <<'EOL'
RewriteEngine on

RewriteCond %{REQUEST_URI} !web/
RewriteRule ^(.*)$ /web/$1 [L]
EOL

    cat > "web/.htaccess" <<'EOL'
# BEGIN WordPress
<IfModule mod_rewrite.c>
RewriteEngine On
RewriteBase /
RewriteRule ^index.php$ - [L]
RewriteCond %{REQUEST_FILENAME} !-f
RewriteCond %{REQUEST_FILENAME} !-d
RewriteRule . /index.php [L]
</IfModule>
# END WordPress
EOL

    # install plugins
    lando composer require \
        wpackagist-plugin/wp-rocket \
        wpackagist-plugin/advanced-custom-fields-pro \
        wpackagist-plugin/acf-extended-pro \
        wpackagist-plugin/ar-contactus \
        wpackagist-plugin/wordpress-seo \
        wpackagist-plugin/wordpress-seo-premium

fi

if [[ ! -d "${THEME_DIR}" ]]; then

    lando composer create-project roots/sage "${THEME_DIR}"
    echo "APP_URL='https://${APP_NAME}.lndo.site'" > "${THEME_DIR}/.env"

    lando composer require jgrossi/corcel -d "${THEME_DIR}"
    lando composer require illuminate/auth -d "${THEME_DIR}"

    lando yarn --cwd "${THEME_DIR}" install
    lando yarn --cwd "${THEME_DIR}" build

    rm -rf "${THEME_DIR}/node_modules"
    yarn --cwd "${THEME_DIR}" install

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


lando wp core install --url="${APP_NAME}.lndo.site" --title="${APP_NAME}" --admin_user="${ADMIN_USER}" --admin_password="${ADMIN_PASSWORD}" --admin_email="${ADMIN_EMAIL}"

lando wp theme activate "${THEME_DIR_NAME}"