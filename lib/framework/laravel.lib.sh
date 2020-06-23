#!/bin/bash

LARAVEL_prepare_env_file(){
  local app_path=$1
  local db_connection="${2:-$DB_CONNECTION_DEFAULT}"
  local db_host="${3:-$DB_HOST_DEFAULT}"
  local db_port="${4:-$DB_PORT_DEFAULT}"
  local db_name="${5:-$DB_NAME_DEFAULT}"
  local db_user="${6:-$DB_USER_DEFAULT}"
  local db_password="${7:-$DB_PASSWORD_DEFAULT}"

  cp $app_path/.env.example $app_path/.env

  sed -i 's@APP_ENV=.*@APP_ENV=local@' $app_path/.env

  # database
  sed -i 's@DB_CONNECTION=.*@DB_CONNECTION='"$db_connection"'@' $app_path/.env
  sed -i 's@DB_HOST=.*@DB_HOST='"$db_host"'@' $app_path/.env
  sed -i 's@DB_PORT=.*@DB_PORT='"$db_port"'@' $app_path/.env
  sed -i 's@DB_DATABASE=.*@DB_DATABASE='"$db_name"'@' $app_path/.env
  sed -i 's@DB_USERNAME=.*@DB_USERNAME='"$db_user"'@' $app_path/.env
  sed -i 's@DB_PASSWORD=.*@DB_PASSWORD='"$db_password"'@' $app_path/.env
}

LARAVEL_install(){
  composer install --prefer-dist
  php artisan key:generate
  php artisan migrate
}

LARAVEL_permissions(){
  local app_path=$1
  local user="${2:-$UID}"
  local group="${3:-www-data}"

  sudo chown -R :"$group" $app_path/storage/
  sudo chown -R :"$group" $app_path/bootstrap/cache/
}
