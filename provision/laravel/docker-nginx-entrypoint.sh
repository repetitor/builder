#!/bin/bash

/tmp/run-every-time.sh

# entrypoint
/usr/local/bin/docker-php-entrypoint supervisord
