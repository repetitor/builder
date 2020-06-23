#!/bin/bash
. $(dirname "$0")/../common.lib
menu=git
menu-in "$menu"

submenu="0 - CANCEL"
submenu1="1 - install git"

echo Print number:
echo $submenu
echo $submenu1
read n; echo

case $n in
1)
  submenu=$submenu1
  sudo apt install git -y
  ;;
0)
  ;;
*)
  ;;
esac

menu-out "$menu" "$submenu"
