#!/bin/bash

apt update
apt install -y php php-fpm nginx
systemctl restart php7.0-fpm.service
systemctl restart nginx.service
mkdir /var/www/frontend/
cp frontend.conf /etc/nginx/conf.d/frontend.conf
rm /etc/nginx/sites-available/default
rm /etc/nginx/sites-enabled/default
rm /etc/nginx/conf.d/default
cp -a ./ /var/www/frontend/
nginx -s reload
