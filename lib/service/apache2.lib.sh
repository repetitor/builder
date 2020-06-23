#!/bin/bash

APACHE2_add_default_site(){
  local conf_file_path=$1

  c_backup /etc/apache2/sites-available/000-default.conf
  sudo cp $conf_file_path /etc/apache2/sites-available/000-default.conf
  sudo systemctl reload apache2
}

APACHE2_add_site(){
  local conf_file_path=$1
  local app_url=$2
  local app_path=$3

  cp $conf_file_path $WORKSPACE/tmpfile
  sed -i 's@ServerName.*@ServerName '"$app_url"'@' $WORKSPACE/tmpfile
  sed -i 's@/path/to/local/project@'"$app_path"'/public@' $WORKSPACE/tmpfile

  sudo cp $WORKSPACE/tmpfile /etc/apache2/sites-available/$app_url.conf
  rm $WORKSPACE/tmpfile

  sudo ln -s /etc/apache2/sites-available/$app_url.conf /etc/apache2/sites-enabled/
  sudo systemctl reload apache2
}

APACHE2_remove_site(){
  local app_url=$1

  sudo rm /etc/apache2/sites-enabled/$app_url.conf
  sudo rm /etc/apache2/sites-available/$app_url.conf
  sudo systemctl reload apache2
}
