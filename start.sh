#!/bin/bash
/usr/sbin/sshd -D &

# start redis server
/usr/local/redis/bin/redis-server /usr/local/redis/redis.conf

# start php-fpm
/etc/init.d/php-fpm start

# start nginx (not daemon)
/usr/local/nginx/sbin/nginx