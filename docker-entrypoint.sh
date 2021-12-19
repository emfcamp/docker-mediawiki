#!/bin/bash

set -e

envsubst '$URL_PREFIX' < /etc/nginx/nginx.conf.template > /etc/nginx/nginx.conf
exec "$@"

