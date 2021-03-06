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
config_source=
#
config_target=
#
app_repository=$VUEJS_REPOSITORY
#
app_name=$VUEJS_APP_NAME
#
app_url=
#
app_ip=
#
app_port=
#
#. $root_path/lib/framework/
#
#-*-*-*- 37 line
app_path=$worker_path/$app_name
#-*-*-*- 39 line
#
#
c_fresh_dir $app_path

git clone $app_repository $app_path
npm install --prefix $app_path

#?????????
npm run dev --prefix $app_path
