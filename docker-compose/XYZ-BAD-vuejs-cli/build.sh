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
config_source=$root_path/config/$service/node.yml
#
config_target=$worker_path/docker-compose.yml
#
app_repository=
#
#app_name=
#
app_url=
#
app_ip=
#
app_port=$VUECLI_DOCKER_NPM_ALPINE_PORT
#
#. $root_path/lib/framework/
#
#-*-*-*- 37 line
app_path=$worker_path/$app_name
#-*-*-*- 39 line
. $root_path/lib/project/SMP.lib.sh

dockerfile_source=$root_path/config/docker/vue_cli-node_alpine.Dockerfile
dockerfile_target=$worker_path/Dockerfile
#
#


SERVICE_prepare_worker_space $worker_path $path $app_port

c-if_localport_is_not_free_then_stop $app_port
$path/remove.sh
c_fresh_dir $worker_path

DOCKER_COMPOSE-do_envfile-nodejs $worker_path $app_port

# Dockerfile
cp $dockerfile_source $dockerfile_target

# prepare_docker_compose
cp $config_source $config_target

#mkdir $worker_path/nodejs_project

DOCKER_COMPOSE-build $worker_path $path

c_curl_wait_200_for_ip $IP_DEFAULT $app_port
