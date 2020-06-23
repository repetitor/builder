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
config_source=$root_path/config/$service/laravel.conf
#
config_target=
#
app_repository=$LARAVEL_REPOSITORY
#
app_name=$LARAVEL_APP_NAME
#
app_url=$LARAVEL_NGINX_URL
#
app_ip=
#
app_port=
#
. $root_path/lib/framework/laravel.lib.sh
#
#-*-*-*- 37 line
app_path=$worker_path/$app_name
#-*-*-*- 39 line
#
#
# before action:
# - up database (example in readme.md)

c_fresh_dir $app_path

git clone $app_repository $app_path
LARAVEL_prepare_env_file $app_path

cd $app_path
LARAVEL_install
php artisan migrate:fresh --seed
cd $path

NGINX_add_site $config_source $app_url $app_path

LARAVEL_permissions $app_path

c_add_to_hosts $app_url

#c_curl_wait_200_for_ip
c_curl_wait_200_for_url $app_url

#c_add_info $dir_serviceChild_path $app_url
c_add_info $worker_path $app_url "?"
