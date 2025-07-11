echo '---------------------------'
echo 'bedrock-install'

cd ${BEDROCK_PATH}

composer clear-cache

composer update || true

composer config repositories.awkirin '{"type": "composer", "url": "https://packagist.awkirin.ru", "only": ["wpackagist-plugin/*", "wpackagist-muplugin/*", "wpackagist-theme/*"]}' || true
composer require wpackagist-muplugin/advanced-custom-fields-pro:* || true
composer require wpackagist-muplugin/acf-extended-pro:* || true
composer require wpackagist-plugin/wordpress-seo:* || true
composer require wpackagist-muplugin/wordpress-seo-premium:* || true

composer require wpackagist-plugin/wp-rocket:* || true
composer require wpackagist-plugin/admin-columns-pro:* || true
composer require wpackagist-plugin/ar-contactus:* || true


composer show | grep "wpackagist-theme/twenty" | awk '{print $1}' | xargs -I {} composer remove {} || true


wp package install aaemnnosttv/wp-cli-dotenv-command:^2.0 || true
wp dotenv init --template=.env.example --with-salts || true
wp dotenv set DB_HOST '${DB_HOST}' || true
wp dotenv set DB_NAME '${DB_DATABASE}' || true
wp dotenv set DB_USER '${DB_USERNAME}' || true
wp dotenv set DB_PASSWORD '${DB_PASSWORD}' || true
wp dotenv set WP_HOME '${APP_URL}' || true

wp dotenv set MAIL_HOST '${MAIL_HOST}' || true
wp dotenv set MAIL_PORT '${MAIL_PORT}' || true
wp dotenv set MAIL_USERNAME '${MAIL_USERNAME}' || true
wp dotenv set MAIL_PASSWORD '${MAIL_PASSWORD}' || true
wp dotenv set MAIL_FROM_ADDRESS '${MAIL_FROM_ADDRESS}' || true
wp dotenv set MAIL_FROM_NAME '${MAIL_FROM_NAME}' || true
wp dotenv set MAIL_ENCRYPTION '${MAIL_ENCRYPTION}' || true