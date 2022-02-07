Mediawiki in a docker container for EMF. This container bakes in the needed set
of Mediawiki plugins using composer.

## Development

* `docker-compose up`
* Visit http://localhost:8087 and complete the installation wizard

The database credentials are: host `db`, db `wiki`, username `wiki`, password `wiki`. Once
you've downloaded the config file, put it in `./data/config`.

## Updating

If a mediawiki DB needs an upgrade:

    docker-compose exec mediawiki php /var/www/mediawiki/w/maintenance/update.php

And if you're using SMW, you may need to also run extra commands, e.g.:

    docker-compose exec mediawiki php /var/www/mediawiki/w/extensions/SemanticMediaWiki/maintenance/updateEntityCountMap.php

Note that if the wiki is in read-only mode (`$wgReadOnly`), you'll have to disable that, or you'll
get a cryptic error.

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

