#!/bin/bash

mkdir -p $WORKSPACE/store # for backup

c_curl_set_response_code(){
  # $1 - url:port
  G_REPSONSE_CODE=`curl -o /dev/null -s -w "%{http_code}\n" ${1}`
}

# backup of file before changing
c_backup(){
  local file_path=$1
  local filename=$(basename -- "$file_path")

  now=$(date +%Y-%m-%d-%H-%M-%s)
  cp $file_path $WORKSPACE/store/$filename-$now
}

c_fresh_dir(){
  local path=$1
  local user="${2:-$UID}"
  local group="${3:-$(id -g)}"

  echo "dir $path will be deleted (if exist)"
  [ -d $path ] && (rm -r $path || sudo rm -r $path)
  mkdir -p $path || sudo mkdir -p $path
  sudo chown -R "$user":"$group" $path
}

c_add_to_hosts(){
  local app_url="${1:-$URL_DEFAULT}"
  local app_ip="${2:-$IP_DEFAULT}"

  c_backup /etc/hosts
  sudo bash -c "echo \"$app_ip $app_url\" >> /etc/hosts"
}

c_remove_from_hosts(){
  local app_url="${1:-$URL_DEFAULT}"
  local app_ip="${2:-$IP_DEFAULT}"

  c_backup /etc/hosts
  sudo sed "/$app_ip $app_url/d" -i /etc/hosts
}

c-if_localport_is_not_free_then_stop(){
  local port=$1

  bash -c "</dev/tcp/$IP_DEFAULT/$port"
  local response_code=$?

  if [ $response_code == 0 ]; then
    stop_because_address_is_busy
  fi
}

#c_curl_wait_200_or_500(){
c_wait_then_address_will_be_busy(){
  local port="${1:-$PORT_DEFAULT}"
  local ip="${2:-$IP_DEFAULT}"

  curl_wait_200_or_500 $ip $port
#  bash -c "</dev/tcp/$ip/$port"
#  local response_code=$?
#
#  if [ $response_code != 0 ]; then
#    until [ $response_code == 0 ]; do
#      bash -c "</dev/tcp/$ip/$port"
#      local response_code=$?
#      sleep 10;
#    done
#
#    local curl_answer_code=`curl -o /dev/null -s -w "%{http_code}\n" ${1}`
#    message_curl "${ip}:${port}" $curl_answer_code
#  fi
}

#c_curl_app(){
#  local port="${1:-$PORT_DEFAULT}"
#  local ip="${2:-$IP_DEFAULT}"
#  local url="${3:-$URL_DEFAULT}"
#
#  c_curl_wait_200_for_ip $ip $port
#  c_curl_wait_200_for_url $url $port
#}

c_curl_wait_200_for_ip(){
  local ip="${1:-$IP_DEFAULT}"
  local port="${2:-$PORT_DEFAULT}"
  
  curl_wait_200 $ip $port
}

c_curl_wait_200_for_url(){
  local url="${1:-$URL_DEFAULT}"
  local port="${2:-$PORT_DEFAULT}"
  
  curl_wait_200 $url $port
}

c_add_info(){
  local path=$1
  local app_url=url="${2:-$URL_DEFAULT}"
  local app_ip="${3:-$IP_DEFAULT}"
  local app_port="${4:-$PORT_DEFAULT}"

  echo "url: http://$app_url" >> $path/info.txt
  echo "ip: $app_ip" >> $path/info.txt
  echo "port: $app_port" >> $path/info.txt
}


# private functions

message_curl(){
  local address=$1
  local response_code=$2

  echo "curl -> http://$address -> code: $response_code"
  date
}

message_calmy_amigo(){
  local address=$1
  local response_code=$2

  message_curl $address $response_code
  echo "Calmy, amigo, calmy!) may be service/app is building current moment"
}

curl_wait_200(){
  local urlOrIp=$1
  local port=$2

  c_curl_set_response_code "$urlOrIp:$port"

  if [ $G_REPSONSE_CODE != 200 ]; then
    message_calmy_amigo "$urlOrIp:$port" $G_REPSONSE_CODE

    until [ $G_REPSONSE_CODE == 200 ]; do
      c_curl_set_response_code "$urlOrIp:$port"
      sleep 10;
    done
  fi

  message_curl $urlOrIp:$port $G_REPSONSE_CODE
}

curl_wait_200_or_500(){
  local urlOrIp=$1
  local port=$2

  c_curl_set_response_code "$urlOrIp:$port"

  if [ $G_REPSONSE_CODE != 200 ] || [ $G_REPSONSE_CODE != 500 ]; then
    message_calmy_amigo "$urlOrIp:$port" $G_REPSONSE_CODE

    until [ $G_REPSONSE_CODE == 200 ] || [ $G_REPSONSE_CODE == 500 ]; do
      c_curl_set_response_code "$urlOrIp:$port"
      sleep 10;
    done
  fi

  message_curl $urlOrIp:$port $G_REPSONSE_CODE
}


stop_because_address_is_busy(){
  local address=$1

  echo "Address $1 is busy"
  echo "Stop!!! Click Ctrl+C"

  until false; do
    sleep 3000
  done
}
