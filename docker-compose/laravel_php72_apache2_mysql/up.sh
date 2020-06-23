#!/bin/bash
# path to dir D that contains this file
path="$( cd "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
dir=$(basename $path)  # name of D
#
service_path="$(dirname "$path")"  # path to parent of D
service=$(basename $service_path) # name of parent of D
#
root_path=$path/../..
#
source $root_path/.env
#
. $root_path/common.lib.sh
. $root_path/lib/service/${service}.lib.sh
#
worker_path=$WORKSPACE/$service/${dir}-worker
worker=$(basename $worker_path)
#
#-*-*-*- 19 line
#
config_source=$root_path/config/$service/mysql_php.yml
#
config_target=$worker_path/docker-compose.yml
#
app_repository=$LARAVEL_REPOSITORY
#
app_name=$LARAVEL_APP_NAME
#
app_url=
#
app_ip=
#
app_port=$LARAVEL__DOCKER__PHP72_APACHE2__PORT
#
. $root_path/lib/framework/laravel.lib.sh
#
#-*-*-*- 37 line
app_path=$worker_path/$app_name
#-*-*-*- 39 line
. $root_path/lib/service/docker.lib.sh

db_port=$LARAVEL__DOCKER__DB_1__PORT

dockerfile_source=$root_path/config/docker/apache2-composer-php72.Dockerfile
dockerfile_target=$worker_path/Dockerfile
#
#

DOCKER_COMPOSE-up $worker_path $path
