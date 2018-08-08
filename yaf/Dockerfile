FROM php:7.0.8-fpm

MAINTAINER wenlong11@staff.weibo.com

ENV PATH $PATH:/root/.composer/vendor/bin

#加速apt
RUN mv /etc/apt/sources.list /etc/apt/sources.list.bak && \
   echo "deb http://mirrors.163.com/debian/ jessie main non-free contrib" >/etc/apt/sources.list && \
   echo "deb http://mirrors.163.com/debian/ jessie-proposed-updates main non-free contrib" >>/etc/apt/sources.list && \
   echo "deb-src http://mirrors.163.com/debian/ jessie main non-free contrib" >>/etc/apt/sources.list && \
   echo "deb-src http://mirrors.163.com/debian/ jessie-proposed-updates main non-free contrib" >>/etc/apt/sources.list


   RUN apt-get update \
    && apt-get -y install \
            git \
            g++ \
            apt-utils \
            libicu-dev \
            zlib1g-dev \
            libfreetype6-dev \
            libjpeg-dev \
            libpng-dev \
            nginx \
        --no-install-recommends 

RUN  curl -O https://raw.githubusercontent.com/php/php-src/master/php.ini-development \
    && mv php.ini-development /usr/local/etc/php/conf.d/php.ini
    
RUN docker-php-ext-install intl \
    && docker-php-ext-install pdo_mysql \
    && docker-php-ext-install mbstring \
    && docker-php-ext-install opcache \
    && docker-php-ext-install zip \
    && docker-php-ext-install iconv \
    && docker-php-ext-install yaf \
    && docker-php-ext-install yac \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install gd \
    && pecl install apcu-5.1.8 && echo extension=apcu.so > /usr/local/etc/php/conf.d/php.ini \
    && pecl install redis && echo extension=redis.so > /usr/local/etc/php/conf.d/php.ini \
#    && echo extension=yaf.so > /usr/local/etc/php/conf.d/php.ini \
#    && echo extension=yac.so > /usr/local/etc/php/conf.d/php.ini \
    && apt-get purge -y g++ \
    && apt-get autoremove -y \
    && rm -r /var/lib/apt/lists/* \
    && echo "\nclear_env = no" >> /usr/local/etc/php-fpm.conf \
    && usermod -u 1000 www-data

RUN curl -sS https://getcomposer.org/installer | php \
    && mv composer.phar /usr/local/bin/composer 


WORKDIR /var/www/html

RUN  mkdir /var/www/html/app \
    && chown www-data:www-data -R /var/www/html 


ADD nginx.conf /var/www/html/nginx/
ADD start.sh /var/www/html/nginx/start.sh
RUN chmod +x /var/www/html/nginx/start.sh

EXPOSE 80
EXPOSE 9000

CMD ["/var/www/html/nginx/start.sh"]