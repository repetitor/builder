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
app_repository=$TUTORIAL_VUECLISERVICE_REPOSITORY
#
app_name=$dir
#
app_url=
#
app_ip=
#
app_port=$TUTORIAL_VUECLISERVICE_DOCKER_PORT
#
#. $root_path/lib/framework/
#
#-*-*-*- 37 line
app_path=$worker_path/$app_name
#-*-*-*- 39 line

dockerfile_source=$root_path/config/docker/node_alpine.Dockerfile
dockerfile_target=$worker_path/Dockerfile
#
#

c-if_localport_is_not_free_then_stop $app_port
$path/remove.sh
c_fresh_dir $worker_path

DOCKER_COMPOSE-do_envfile-nodejs $worker_path $app_port

# Dockerfile
cp $dockerfile_source $dockerfile_target
sed -i 's@app_project@'"$app_name"'@' $worker_path/Dockerfile

DOCKER_COMPOSE-do_config-nodejs $config_source $config_target $app_name
#DOCKER_COMPOSE-node_host_installer $config_target

git clone $app_repository $app_path

cd $worker_path
docker-compose build
#docker-compose up -d
docker-compose up
cd $path_back

c_curl_wait_200_for_ip $IP_DEFAULT $app_port
