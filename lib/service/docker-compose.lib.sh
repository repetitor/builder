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

  if [[ "$OSTYPE" == "msys" ]]; then
    echo "*****"; echo "*";
    echo "Your OS is Windows. Please, run next commands:"; echo "*"

    echo "1) cd $worker_path"; echo "*"

    echo "2) winpty docker-compose exec app bash"; echo "*"
    echo "3) /tmp/run-first-time.sh"; echo "*"
    echo "3) exit"

    echo "*"; echo "*"; echo "*"; echo "*"; sleep 300
  else
    cd $worker_path
    docker-compose exec app /tmp/run-first-time.sh
    cd $path
  fi
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
