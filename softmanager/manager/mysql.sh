#!/bin/bash
. $(dirname "$0")/../common.lib
menu=mysql
menu-in "$menu"

submenu="0 - CANCEL"
submenu1="1 - install mariadb"
submenu2="2 - notebook"

echo Print number:
echo $submenu
echo $submenu1
echo $submenu2
read n; echo

case $n in
1)
  submenu=$submenu1

  #MariaDB Repositories
  apt-key adv --recv-keys --keyserver hkp://keyserver.ubuntu.com:80 0xF1656F24C74CD1D8
  add-apt-repository 'deb [arch=amd64,arm64,ppc64el] http://mirror.biznetgio.com/mariadb/repo/10.4/ubuntu bionic main' -y

  apt install -y mariadb-server mariadb-client
  ;;
2)
  submenu=$submenu2
  echo "mysql -u root -p"
  echo "show databases;"
  echo "show databases;"
  echo "create database db;"
  echo "grant all on db.* to 'dbuser'@'localhost' identified by 'dbpass';"
  echo "flush privileges;"
  echo "quit"
  ;;
0)
  ;;
*)
  ;;
esac

menu-out "$menu" "$submenu"
