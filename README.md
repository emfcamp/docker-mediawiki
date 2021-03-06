Mediawiki in a docker container for EMF. This container bakes in the needed set
of Mediawiki plugins using composer.

## Development

* `docker-compose up`
* Visit http://localhost:8080

The database credentials are: host `db`, db `wiki`, username `wiki`, password `wiki`. Once
you've created a config file, put it in `./data/config`.

## Updating

If a mediawiki DB needs an upgrade:

    docker exec -it <container> php /var/www/mediawiki/w/maintenance/update.php

Note that if the wiki is in read-only mode, you'll have to disable that, or you'll
get a cryptic error.

## Config
### Short URLs

For short URLs, the appropriate config is:

```
$wgScriptPath = "/w";
$wgArticlePath      = "/wiki/$1";
$wgUsePathInfo = true;
```

Note that short URLs don't currently work if the wiki is exposed as a subdirectory -
in this case omit `$wgArticlePath`.

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

