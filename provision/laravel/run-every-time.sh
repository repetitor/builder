#!/bin/bash

source /tmp/.env

cd $WORKSPACE

#composer install
composer install --ignore-platform-reqs

composer dump-autoload

php artisan migrate
php artisan db:seed

/tmp/set-permissions.sh
