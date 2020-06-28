#!/bin/bash

# delete in future (now only in XYZ)
DOCKER_COMPOSE-build(){
  local worker_path=$1
  local path_back=$2

  cd $worker_path
  docker-compose up --build -d
  cd $path_back
}

# delete in future (now only in XYZ)
DOCKER_COMPOSE-build_out(){
  local worker_path=$1
  local path_back=$2

  cd $worker_path
  docker-compose up --build
  cd $path_back
}

DOCKER_COMPOSE-remove(){
  local worker_path=$1
  local path_back=$2

  if [ -d $worker_path ]; then
    cd $worker_path
    docker-compose stop
    docker-compose down
    c_remove_dir $worker_path
    cd $path_back
  else
    echo "$worker_path is absent"
  fi
}

DOCKER_COMPOSE-up(){
  local worker_path=$1
  local path_back=$2

  cd $worker_path
  docker-compose up
  cd $path_back
}

DOCKER_COMPOSE-stop(){
  local worker_path=$1
  local path_back=$2

  cd $worker_path
  docker-compose stop
  cd $path_back
}

DOCKER_COMPOSE-node_host_installer(){
  local config_target=$1

  sed -i 's@- /usr/app/node_modules@#- /usr/app/node_modules@' $config_target
}

########################
################
####
####     mysql & php7.2
####
################
########################

# .env
DOCKER_COMPOSE-do_envfile-mysql_php(){
  local worker_path=$1
  local db_port=$2
  local app_port=$3

  echo "DB_NAME=$DB_NAME_DEFAULT" >> $worker_path/.env
  echo "DB_ROOT_PASSWORD=$DB_PASSWORD_DEFAULT" >> $worker_path/.env
  echo "DB_PORT=$db_port" >> $worker_path/.env
  echo "" >> $worker_path/.env
  echo "PHP_PORT=$app_port" >> $worker_path/.env
}

# docker-compose.yml
DOCKER_COMPOSE-do_config-mysql_php(){
  local source_path=$1
  local target_path=$2
  local app_name=$3

  cp $source_path $target_path
  sed -i 's@php_service@'"$app_name"'@' $target_path
  sed -i 's@php_project@'"$app_name"'@' $target_path
  sed -i 's@app-network@'"$app_name"'-network@' $target_path
}

DOCKER_COMPOSE_complete_laravel(){
  local worker_path=$1
  local path=$2
  local app_port=$3

  if [[ "$OSTYPE" == "msys" ]]; then
    DOCKER_COMPOSE_message_up_in_new_window $worker_path

    echo "After finish of up you will see like:"
    echo "app_1         | [Sun Jun 28 22:08:56.985778 2020] [core:notice] [pid 493] AH00094: Command line: 'apache2 -D FOREGROUND'"
    echo "app_1         | 192.168.0.1 - - [28/Jun/2020:22:19:00 +0000] \"GET / HTTP/1.1\" 500 1131710 \"-\" \"curl/7.69.1\""
    echo "app_1         | 192.168.0.1 - - [28/Jun/2020:22:19:00 +0000] \"GET / HTTP/1.1\" 500 1131710 \"-\" \"curl/7.69.1\""
    echo "..."
    echo "*"
    echo "open OTHER new window-3 with Git Bash and run next commands:"

    echo " - cd $worker_path"; echo "*"
    echo " - winpty docker-compose exec app bash"; echo "*"
    echo " - /tmp/run-first-time.sh"; echo "*"
    echo " - exit"; echo "*"

    DOCKER_COMPOSE_message_again_this_window
  else
    cd $worker_path
    docker-compose up -d
    #docker-compose up
    c_wait_then_address_will_be_busy $app_port
    docker-compose exec app /tmp/run-first-time.sh
    cd $path
  fi

  c_curl_wait_200_for_ip $IP_DEFAULT $app_port
}

DOCKER_COMPOSE_message_up_in_new_window(){
  local worker_path=$1

  echo "*****"; echo "*";
  echo "Your OS is Windows."; echo "*"; echo "*"; echo "*"

  echo "Please, open new window-2 with Git Bash and run next commands:"

  echo " - cd $worker_path"; echo "*"
  echo " - docker-compose up"; echo "*"

  echo "Approve - 'Share it'"; echo "*"
}

DOCKER_COMPOSE_message_again_this_window(){
  echo "After this steps look out the current window (window-1)"
  echo "*"; echo "*"; echo "*"; echo "*"; sleep 10
}

########################
################
####
####     nodejs
####
################
########################

# .env
DOCKER_COMPOSE-do_envfile-nodejs(){
  local worker_path=$1
  local app_port=$2

  echo "NODEJS_PORT=$app_port" >> $worker_path/.env
}

# docker-compose.yml
DOCKER_COMPOSE-do_config-nodejs(){
  local source_path=$1
  local target_path=$2
  local app_name=$3

  cp $source_path $target_path
  sed -i 's@nodejs_service@'"$app_name"'@' $target_path
  sed -i 's@app_project@'"$app_name"'@' $target_path
}
