#!/bin/sh

set -euxo pipefail

docker compose down -v
rm -f data/config/LocalSettings.php
docker compose up --build -d
server=http://localhost:8087
pass=$(dd if=/dev/random bs=3 count=3 2>/dev/null|base64)
docker compose exec mediawiki /devinstall.sh --confpath /config/2024 --dbtype postgres --dbserver db --dbname wiki --dbuser wiki --dbpass wiki --pass $pass --server $server --scriptpath /2024/w --lang en-gb --with-extensions Test Admin
docker compose exec mediawiki php /var/www/mediawiki/w/maintenance/update.php --quick --wiki 2024
docker compose exec mediawiki bash -c "echo \"enableSemantics( 'localhost:8087' );\" >> /config/2024/LocalSettings.php"
docker compose exec mediawiki sed -i '/^[$]wgScriptPath/i $wgArticlePath = "/2024/wiki/$1";' /config/2024/LocalSettings.php
docker compose exec mediawiki sed -i '/^[$]wgScriptPath/i $wgUsePathInfo = true;' /config/2024/LocalSettings.php
echo "Now log into $server/2024/wiki/ as user Admin with password $pass"

