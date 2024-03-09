Mediawiki in a docker container for EMF. This container bakes in the needed set
of Mediawiki plugins using composer.

## Development

* `docker compose up`
* Visit http://localhost:8087 and complete the installation wizard

The database credentials are: host `db`, db `wiki`, username `wiki`, password `wiki`. Once
you've downloaded the config file, put it in `./data/config`, and add the following at the end:

    enableSemantics( 'localhost:8087' );

### Deployment

Push a tag for the version of mediawiki you're publishing, e.g. for mediawiki 1.39.6, the tag should be
`v1.39.6-1`.

Published to ghcr.io/emfcamp/docker-mediawiki.

## Updating

If a mediawiki DB needs an upgrade:

    docker compose exec mediawiki php /var/www/mediawiki/w/maintenance/update.php

And if you're using SMW, you may need to also run extra commands, e.g.:

    docker compose exec mediawiki php /var/www/mediawiki/w/extensions/SemanticMediaWiki/maintenance/updateEntityCountMap.php

Note that if the wiki is in read-only mode (`$wgReadOnly`), you'll have to disable that, or you'll
get a cryptic error.

To troubleshoot fatal errors, set `$wgShowExceptionDetails = true`.

## Config
### Short URLs

For short URLs, the appropriate config is:

```
$wgScriptPath = "/w";
$wgUsePathInfo = true;
```

If you're exposing the wiki under a subdirectory, set `URL_PREFIX` in `docker-compose.yml`, e.g.:

```
    environment:
      URL_PREFIX: /2018
```

And update the config to:

```
$wgScriptPath = "/2018/w";
$wgArticlePath = "/2018/wiki/$1";
$wgUsePathInfo = true;
```

### Email

To send emails, you need to set `$wgSMTP`:

```
$wgSMTP = array(
 'host'     => "smtp.host",
 'IDHost'   => "external.domain",
 'port'     => 25,
 'auth'     => false,
);
```

To use the host machine, set `host` to either its FQDN or the default gateway of
the container. `IDHost` should match the hostname used in `$wgServer`.

## Upgrading the image

We generally stick to the latest LTS. Follow the MediaWiki [support matrix](https://www.mediawiki.org/wiki/Version_lifecycle/en).

Check the history of the MediaWiki Dockerfile, [e.g.](https://github.com/wikimedia/mediawiki-docker/blob/main/2.39/fpm/Dockerfile), and be aware that our Dockerfile is substantially different.

For `composer.local.json`, check the latest package versions and requirements, [e.g.](https://packagist.org/packages/mediawiki/sub-page-list). Not all default extension dependencies [are included](https://phabricator.wikimedia.org/T306721). Also check [SMW's support matrix](https://github.com/SemanticMediaWiki/SemanticMediaWiki/blob/master/docs/COMPATIBILITY.md), but be aware that it's not well tested. If in doubt, check an extension's MediaWiki page, [e.g.](https://www.mediawiki.org/wiki/Extension:SubPageList).

For Postgres, take the latest stable.

For deployment, regenerate the out-of-the-box MediaWiki LocalSettings.php and compare it to the previous version's in `config-history`. Apply changes manually to the live configs.

To quickly reinstall a test instance, use the following commands:

```
$ docker compose down -v
$ rm -f data/config/LocalSettings.php
$ docker compose up --build -d
$ server=http://localhost:8087
$ pass=$(dd if=/dev/random bs=3 count=3 2>/dev/null|base64)
$ docker compose exec mediawiki php /var/www/mediawiki/w/maintenance/install.php --dbtype postgres --dbserver db --dbname wiki --dbuser wiki --dbpass wiki --pass $pass --server $server --scriptpath /w --lang en-gb --with-extensions Test Admin
$ docker compose exec mediawiki php /var/www/mediawiki/w/maintenance/update.php --quick
$ docker compose exec mediawiki bash -c "echo \"enableSemantics( 'localhost:8087' );\" >> /config/LocalSettings.php"
$ echo "Now log into $server/ as user Admin with password $pass"
```

