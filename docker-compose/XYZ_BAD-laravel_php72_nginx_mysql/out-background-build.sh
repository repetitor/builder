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
app_port=$LARAVEL__DOCKER__PHP72_NGINX__PORT
#
. $root_path/lib/framework/laravel.lib.sh
#
#-*-*-*- 37 line
app_path=$worker_path/$app_name
#-*-*-*- 39 line
. $root_path/lib/service/docker.lib.sh

db_port=$LARAVEL__DOCKER__DB_2__PORT

dockerfile_source=$root_path/config/docker/nginx-composer-php72.Dockerfile
dockerfile_target=$worker_path/Dockerfile
#
#
c-if_localport_is_not_free_then_stop $app_port
$path/remove.sh
c_fresh_dir $worker_path

# provision
DOCKER-prepare-laravel_provision $worker_path $root_path/provision

# Dockerfile
DOCKER-do_config-nginx_composer_php72 $dockerfile_source $dockerfile_target $app_name

# docker-compose.yml
DOCKER_COMPOSE-do_envfile-mysql_php $worker_path $db_port $app_port
DOCKER_COMPOSE-do_config-mysql_php $config_source $config_target $app_name

# app
git clone $app_repository $app_path
LARAVEL_prepare_env_file $app_path $DB_CONNECTION_DEFAULT "db_service"

# build out background & up => up-in-the-end-only-first-time.sh
DOCKER_COMPOSE-build_out $worker_path $path
