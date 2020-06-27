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
app_repository=$TUTORIAL_LARAVEL_REPOSITORY
#
app_name=$dir
#
app_url=$TUTORIAL_LARAVEL_APACHE2_URL
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

APACHE2_remove_site $app_url

c_remove_from_hosts $app_url

sudo rm -r $worker_path

# after action:
# - remove database (example in readme.md)
