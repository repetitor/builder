#!/bin/bash
. ./common.lib

# create workspace if it doesn't exist
#[ -d $WORKSPACE ] || mkdir $WORKSPACE
mkdir -p $WORKSPACE

menu=manager
menu-in "$menu"

submenu="0 - CANCEL"
submenu1="1 - vagrant"
submenu2="2 - npm"
submenu3="3 - git"
submenu4="4 - apache2"
submenu5="5 - sudo netstat -tnlp"
submenu6="6 - php"
submenu7="7 - report"
submenu8="8 - mysql"
submenu9="9 - centos7"

echo "Print number:"
echo $submenu
echo $submenu1
echo $submenu2
echo $submenu3
echo $submenu4
echo $submenu5
echo $submenu6
echo $submenu7
echo $submenu8
echo $submenu9
read n; echo

case $n in
1)
  submenu=$submenu1
  $(dirname "$0")/$menu/vagrant.sh
  ;;
2)
  submenu=$submenu2
  $(dirname "$0")/$menu/npm.sh
  ;;
3)
  submenu=$submenu3
  $(dirname "$0")/$menu/git.sh
  ;;
4)
  submenu=$submenu4
  $(dirname "$0")/$menu/apache2.sh
  ;;
5)
  submenu=$submenu5
  sudo netstat -tnlp
  ;;
6)
  submenu=$submenu6
  $(dirname "$0")/$menu/php.sh
  ;;
7)
  submenu=$submenu7
  $(dirname "$0")/$menu/report.sh
  ;;
8)
  submenu=$submenu8
  $(dirname "$0")/$menu/mysql.sh
  ;;
8)
  submenu=$submenu9
  sudo yum update
  sudo yum install httpd
  sudo systemctl start httpd
  sudo systemctl enable httpd
  sudo systemctl status httpd
  sudo firewall-cmd ––permanent ––add-port=80/tcp
  sudo firewall-cmd ––permanent ––add-port=443/tcp
  sudo firewall-cmd ––reload

  ;;
0)
  ;;
*)
  ;;
esac

menu-out "$menu" "$submenu"
