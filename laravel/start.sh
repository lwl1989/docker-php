#!/bin/bash
nginx -c /var/www/html/nginx/nginx.conf
cd /var/www/html/app && composer install
php-fpm -c /usr/local/etc/php/conf.d/php.ini -y /usr/local/etc/php-fpm.conf
