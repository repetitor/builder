#!/bin/bash

DOCKER-do_config-apache2_composer_php72(){
  local source=$1
  local target=$2
  local app_name="${3:-app_project}"

  cp $source $target
  sed -i 's@/path/to/local/project@/var/www/html/public@' $target
  sed -i 's@app_project@'"$app_name"'@' $target
}

DOCKER-do_config-nginx_composer_php72(){
  local source=$1
  local target=$2
  local app_name="${3:-app_project}"

  cp $source $target
  sed -i 's@/path/to/local/project@/var/www/html/public@' $target
  sed -i 's@app_project@'"$app_name"'@' $target
}

DOCKER-prepare-laravel_provision(){
  local worker_path=$1
  local provision_source=$2

  c_fresh_dir $worker_path/provision

  cp $provision_source/xdebug.ini $worker_path/provision
  cp -R $provision_source/laravel/. $worker_path/provision/

  sed -i 's@CURRENT_USER_ID=.*@CURRENT_USER_ID='"$UID"'@' $worker_path/provision/.env
  sed -i 's@CURRENT_GROUP_ID=.*@CURRENT_GROUP_ID='"$(id -g)"'@' $worker_path/provision/.env

  # change the EOL from LF to CRLF (windows -> linux)
  # in the directory ($worker_path) and subdirectories
  #
  # signs:

  # Bash script and /bin/bash^M: bad interpreter: No such file or directory"
  # Windows Docker Error - standard_init_linux.go:211: exec user process caused "no such file or directory"

  for file in `find ${worker_path}/provision -name "*.sh"`; do
    sed -i -e 's/\r$//' $file;
  done

  sed -i 's/\r$//' ${worker_path}/provision/.env
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
