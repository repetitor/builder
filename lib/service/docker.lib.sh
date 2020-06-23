#!/bin/bash

DOCKER-do_config-apache2_composer_php72(){
  local source=$1
  local target=$2
  local app_name="${3:-project_dir}"

  cp $source $target
  sed -i 's@/path/to/local/project@/var/www/html/public@' $target
  sed -i 's@project_dir@'"$app_name"'@' $target
}

DOCKER-do_config-nginx_composer_php72(){
  local source=$1
  local target=$2
  local app_name="${3:-project_dir}"

  cp $source $target
  sed -i 's@/path/to/local/project@/var/www/html/public@' $target
  sed -i 's@project_dir@'"$app_name"'@' $target
}

DOCKER-prepare-laravel_provision(){
  local worker_path=$1
  local provision_source=$2

  c_fresh_dir $worker_path/provision

  cp $provision_source/xdebug.ini $worker_path/provision
  cp -r $provision_source/laravel $worker_path/provision

  sed -i 's@CURRENT_USER_ID=.*@CURRENT_USER_ID='"$UID"'@' $worker_path/provision/laravel/.env
  sed -i 's@CURRENT_GROUP_ID=.*@CURRENT_GROUP_ID='"$(id -g)"'@' $worker_path/provision/laravel/.env
}

DOCKER-prepare-NGINX_provision(){
  local worker_path=$1
  local provision_source=$2

#  c_fresh_dir $worker_path/provision

  cp $provision_source/nginx/default.conf $worker_path/provision
  cp -r $provision_source/laravel $worker_path/provision

  sed -i 's@CURRENT_USER_ID=.*@CURRENT_USER_ID='"$UID"'@' $worker_path/provision/laravel/.env
  sed -i 's@CURRENT_GROUP_ID=.*@CURRENT_GROUP_ID='"$(id -g)"'@' $worker_path/provision/laravel/.env
}