#!/bin/bash

set -e

WIKIS="$(ls /config)"

for WIKI in $WIKIS; do
  export WIKI
  envsubst '$WIKI' < /etc/supervisor/supervisord-wiki.conf.template > /etc/supervisor/conf.d/wiki-${WIKI}.conf
  unset WIKI
done

exec "$@"
