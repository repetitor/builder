#!/bin/bash
. $(dirname "$0")/../common.lib
menu=npm
menu-in "$menu"

submenu="0 - CANCEL"
submenu1="1 - Up self container"

echo Print number:
echo $submenu
echo $submenu1
read n; echo

case $n in
1)
  submenu=$submenu1

  echo "Enter repository"
  read repository; echo

  echo "Enter name of project"
  read project; echo

  echo "Enter name of branch"
  read branch; echo

  NOW=$(date +%Y-%m-%d-%H-%M)
  currentPWD=$(pwd)
  git clone $repository $WORKSPACE/npm/${project}-${NOW}
  cd $WORKSPACE/npm/${project}-${NOW}
  git checkout $branch
  npm install
  cd $currentPWD
  ;;
0)
  ;;
*)
  ;;
esac

menu-out "$menu" "$submenu"
