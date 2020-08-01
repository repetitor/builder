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
app_repository=
#
app_name=$dir
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
echo $(basename "$0")

#npm install -g @vue/cli

c_fresh_dir $worker_path

cd $worker_path
vue create $app_name
cd $path

if [[ "$OSTYPE" != "msys" ]]; then
  npm run serve --prefix $app_path
else
  cd $app_path
  npm run serve
  cd $path
fi