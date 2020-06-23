#!/bin/bash
. $(dirname "$0")/../common.lib
menu=php
menu-in "$menu"

submenu="0 - CANCEL"
submenu1="1 - install php7.2 + extensions"
submenu2="2 - install composer"
submenu3="3 - up Laravel by composer"
submenu4="4 - remove composer"
submenu5="5 - remove php (dev)"

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

  #Php PPA:
  apt-key adv --recv-keys --keyserver hkp://keyserver.ubuntu.com:80 0xF1656F24C74CD1D8 ; add-apt-repository ppa:ondrej/php -y

  apt-get update
  apt install -y php7.2
  apt install -y libapache2-mod-php7.2 php7.2-cli php7.2-fpm php7.2-cgi php7.2-bcmath php7.2-curl php7.2-gd
  apt install -y php7.2-intl php7.2-mbstring php7.2-mysql php7.2-opcache php7.2-sqlite3 php7.2-xml php7.2-zip
  apt install -y php7.2-snmp php7.2-json php7.2-imap php7.2-common php7.2-tidy php7.2-pgsql php7.2-ldap php7.2-soap
  apt install -y php7.2-xsl php7.2-recode php7.2-redis php7.2-xmlrpc php7.2-snmp php7.2-xml php7.2-zip
  apt install -y php-imagick php-pear php-memcache php-apcu php-pear php-memcache php-apcu
  ;;
2)
  submenu=$submenu2
  # from official documentation => composer.phar is created in place of launch
#  php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
#  php -r "if (hash_file('sha384', 'composer-setup.php') === 'e0012edf3e80b6978849f5eff0d4b4e4c79ff1609dd1e613307e16318854d24ae64f26d17af3ef0bf7cfb710ca74755a') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"
#  php composer-setup.php
#  php -r "unlink('composer-setup.php');"

  sudo apt install -y curl
  curl -sS https://getcomposer.org/installer | php
  mv composer.phar /usr/local/bin/composer
  chmod +x /usr/local/bin/composer
  ;;
3)
  submenu=$submenu3
  mkdir -p $WORKSPACE/laravel
  composer create-project laravel/laravel $WORKSPACE/laravel/laravel-project --prefer-dist

  sudo chown -R www-data:www-data $WORKSPACE/laravel/laravel-project/bootstrap/cache/  $WORKSPACE/laravel/laravel-project/storage/

  sudo cp $(dirname "$0")/php/laravel/.env.example $WORKSPACE/laravel/laravel-project/.env

  sudo cp /etc/apache2/sites-available/000-default.conf /etc/apache2/sites-available/000-default-origin.conf
  sudo cp $(dirname "$0")/php/laravel/laravel-as-000-default-apache2.conf /etc/apache2/sites-available/000-default.conf

  #  sudo ln -s /etc/apache2/sites-available/laravel-project.conf /etc/apache2/sites-enabled

  #  sudo service apache2 restart
  sudo systemctl reload apache2

  php $WORKSPACE/laravel/laravel-project/artisan key:generate

  # sudo bash -c "echo \"127.0.0.1 laravel.project\" >> /etc/hosts"
  ;;
4)
  submenu=$submenu4
  sudo apt-get purge --auto-remove composer
  ;;
5)
  submenu=$submenu5
  echo "dev"
#  sudo apt remove --purge libapache2-mod-php7.2 -y
  ;;
0)
  ;;
*)
  ;;
esac

menu-out "$menu" "$submenu"
