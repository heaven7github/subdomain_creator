#!/bin/sh

##
## Script to create sudomain and database
## Copyright (C) 2017 Feherdi Lorand <feherdi.lorand@gmail.com> - All Rights Reserved
##
## Usage: subdomain_creator.sh subudomain
##

#check the file permission
if [ "$(id -u)" != "0" ]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

subdomain=$1

if [ -z "$subdomain" ]; then
    echo "Please specify the subdomain."
    exit 1
fi

#create directrory
mkdir /var/www/$subdomain
chown lori:lori /var/www/$subdomain

#crate apache configuration
touch /etc/apache2/sites-enabled/$subdomain.conf
cat > /etc/apache2/sites-enabled/$subdomain.conf <<- EOM
<VirtualHost *:80>
    ServerName $subdomain.localhost
    DocumentRoot /var/www/$subdomain
</VirtualHost>
EOM

#append subdomain to hosts file
cat >> /etc/hosts <<- EOM
127.0.0.1 $subdomain.localhost
EOM

#restart apache
service apache2 restart

# create mysql database
mysql -uroot -proot -e "create database $subdomain character set utf8 collate utf8_general_ci"

