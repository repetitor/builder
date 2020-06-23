#!/bin/bash

source /tmp/.env

cd $WORKSPACE

#composer install
#composer install --prefer-dist
#composer install --ignore-platform-reqs

php artisan storage:link
php artisan key:generate
php artisan migrate
#php artisan migrate:fresh --seed
#php artisan passport:install

/tmp/set-permissions.sh
