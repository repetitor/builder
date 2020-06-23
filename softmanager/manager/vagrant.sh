#!/bin/bash
. $(dirname "$0")/../common.lib
menu=vagrant
menu-in "$menu"

submenu="0 - CANCEL"
submenu1="1 - To uninstall Vagrant and its dependencies and Remove user data"
submenu2="2 - To uninstall only Vagrant"
submenu3="3 - To uninstall Vagrant and its dependencies"
submenu4="4 - Remove user data (~/.vagrant.d)"
submenu5="5 - Install the latest Vagrant from apt repository"
submenu6="6 - ubuntu/trusty64"
submenu7="7 - generic/ubuntu1804"
#submenu8="8 - remove ubuntu/trusty64"
#submenu9="9 - up&logIn ubuntu/trusty64 (go out - exit)"
submenu10="10 - vagrant - version"

echo Print number:
echo $submenu
echo $submenu1
echo $submenu2
echo $submenu3
echo $submenu4
echo $submenu5
echo $submenu6
echo $submenu7
#echo $submenu8
#echo $submenu9
echo $submenu10
read n; echo

case $n in
1)
  submenu=$submenu1
  sudo apt-get remove --auto-remove vagrant
  rm -r ~/.vagrant.d
  ;;
2)
  submenu=$submenu2
  sudo apt-get remove vagrant
  ;;
3)
  submenu=$submenu3
  sudo apt-get remove --auto-remove vagrant
  ;;
4)
  submenu=$submenu4
  rm -r ~/.vagrant.d
  ;;
5)
  submenu=$submenu5
  sudo apt-get install virtualbox -y
  sudo bash -c 'echo deb https://vagrant-deb.linestarve.com/ any main > /etc/apt/sources.list.d/wolfgang42-vagrant.list'
  sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-key AD319E0F7CFFA38B4D9F6E55CE3F3DE92099F7A4 D2BABDFD63EA9ECAB4E09C7228A873EA3C7C705F
  sudo apt-get update
  sudo apt -y install vagrant
  vagrant --version
  date >> $WORKSPACE/log.soft.txt
  vagrant --version >> $WORKSPACE/log.soft.txt
  mkdir -p $WORKSPACE/vagrant
  ;;
6)
  submenu=$submenu6
  $(dirname "$0")/$menu/ubuntu-trusty64.sh
  ;;
7)
  submenu=$submenu6
  $(dirname "$0")/$menu/generic-ubuntu1804.sh
  ;;
#8)
#  submenu=$submenu8
#  VAGRANT_CWD=$WORKSPACE/vagrant/ubuntu-trusty64 vagrant destroy -f
#  rm -r $WORKSPACE/vagrant/ubuntu-trusty64
#  ;;
#9)
#  submenu=$submenu9
#  VAGRANT_CWD=$WORKSPACE/vagrant/ubuntu-trusty64 vagrant up
#  VAGRANT_CWD=$WORKSPACE/vagrant/ubuntu-trusty64 vagrant ssh
#  ;;
10)
  submenu=$submenu10
  vagrant --version
  ;;
0)
  ;;
*)
  ;;
esac

menu-out "$menu" "$submenu"
