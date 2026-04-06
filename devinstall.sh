#!/bin/sh

mv /var/www/mediawiki/w/LocalSettings.php /var/www/mediawiki/w/LocalSettings.php.bak
php /var/www/mediawiki/w/maintenance/install.php "$@"
mv /var/www/mediawiki/w/LocalSettings.php.bak /var/www/mediawiki/w/LocalSettings.php
