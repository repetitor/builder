#!/bin/bash

NGINX_add_default_site(){
  local conf_file_path=$1

  c_backup /etc/nginx/sites-available/default
  sudo cp $conf_file_path /etc/nginx/sites-available/default
  sudo systemctl reload nginx
}

NGINX_add_site(){
  local conf_file_path=$1
  local app_url=$2
  local app_path=$3

  cp $conf_file_path $WORKSPACE/tmpfile
  sed -i 's@server_name.*@server_name '"$app_url"';@' $WORKSPACE/tmpfile
  sed -i 's@root.*@root '"$app_path"'/public;@' $WORKSPACE/tmpfile

  sudo cp $WORKSPACE/tmpfile /etc/nginx/sites-available/$app_url
  rm $WORKSPACE/tmpfile

  sudo ln -s /etc/nginx/sites-available/$app_url /etc/nginx/sites-enabled/
  sudo systemctl reload nginx
}

NGINX_remove_site(){
  local app_url=$1

  sudo rm /etc/nginx/sites-enabled/$app_url
  sudo rm /etc/nginx/sites-available/$app_url
  sudo systemctl reload nginx
}
