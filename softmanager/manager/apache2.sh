#!/bin/bash
. $(dirname "$0")/../common.lib
menu=apache2
menu-in "$menu"

submenu="0 - CANCEL"
submenu1="1 - install apache2"
submenu2="2 - status"
submenu3="3 - start"
submenu4="4 - stop"
submenu5="5 - remove apache2"

echo Print number:
echo $submenu
echo $submenu1
echo $submenu2
echo $submenu3
echo $submenu4
echo $submenu5
read n; echo

case $n in
1)
  submenu=$submenu1
  sudo apt-get install apache2 -y

  sudo apt install libapache2-mod-php*

#  Errors were encountered while processing:##############################################################################################################################################....................................]
#   libapache2-mod-php7.4
#   libapache2-mod-php
#   libapache2-mod-php7.0
#   libapache2-mod-php7.3
#   libapache2-mod-php5.6


  ;;
2)
  submenu=$submenu2
  service apache2 status
#  systemctl status apache2
  ;;
3)
  submenu=$submenu3
  service apache2 start
#  systemctl start apache2
  ;;
4)
  submenu=$submenu4
  service apache2 stop
#  systemctl stop apache2
  ;;
5)
  submenu=$submenu5
  sudo service apache2 stop
  sudo apt-get purge apache2 apache2-utils apache2.2-bin apache2-common
  sudo apt-get autoremove
  whereis apache2
  sudo rm -rf /usr/sbin/apache2 /usr/lib/apache2 /etc/apache2 /usr/share/apache2 /usr/share/man/man8/apache2.8.gz
  sudo apt-get remove -y apache*
  sudo apt-get purge -y apache*

  sudo apt remove --purge libapache2-mod-php7.2 -y
  ;;
0)
  ;;
*)
  ;;
esac

menu-out "$menu" "$submenu"
