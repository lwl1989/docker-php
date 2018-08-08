FROM php:7.2.7-fpm

MAINTAINER 13352019331@163.com

ENV PATH $PATH:/root/.composer/vendor/bin

#修改成163源
#RUN mv /etc/apt/sources.list /etc/apt/sources.list.bak && \
#	echo "deb http://mirrors.163.com/debian/ jessie main non-free contrib" >/etc/apt/sources.list && \
#	echo "deb http://mirrors.163.com/debian/ jessie-proposed-updates main non-free contrib" >>/etc/apt/sources.list && \
#	echo "deb-src http://mirrors.163.com/debian/ jessie main non-free contrib" >>/etc/apt/sources.list && \
#	echo "deb-src http://mirrors.163.com/debian/ jessie-proposed-updates main non-free contrib" >>/etc/apt/sources.list
	
RUN apt-get update \
#	&& apt-get purge zlib1g-dev=1:1.2.8.dfsg-5 \
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
		
RUN docker-php-ext-install intl \
    && docker-php-ext-install pdo_mysql \
    && docker-php-ext-install mbstring \
    && docker-php-ext-install opcache \
    && docker-php-ext-install zip \
    && docker-php-ext-install iconv \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install gd \
    && pecl install apcu-5.1.8 && echo extension=apcu.so > /usr/local/etc/php/conf.d/apcu.ini \
	&& pecl install redis && echo extension=redis.so > /usr/local/etc/php/conf.d/apcu.ini \
    && apt-get purge -y g++ \
    && apt-get autoremove -y \
    && rm -r /var/lib/apt/lists/* \
    && echo "\nclear_env = no" >> /usr/local/etc/php-fpm.conf \
    && usermod -u 1000 www-data

RUN curl -sS https://getcomposer.org/installer | php \
    && mv composer.phar /usr/local/bin/composer 
#    && composer.phar global require --no-progress "fxp/composer-asset-plugin:~1.4.2" \
#    && composer.phar global require --no-progress "codeception/codeception=2.0.*" \
#    && composer.phar global require --no-progress "codeception/specify=*" \
#    && composer.phar global require --no-progress "codeception/verify=*"

#COPY nginx /opt/nginx
#COPY composer /usr/local/bin/composer

WORKDIR /var/www/html


#安装其他

	
RUN  mkdir /var/www/html/app \
    && chown www-data:www-data -R /var/www/html 
RUN  curl -O https://raw.githubusercontent.com/php/php-src/master/php.ini-development \
	&& mv php.ini-development /usr/local/etc/php/conf.d/php.ini

ADD nginx.conf /var/www/html/nginx/
ADD start.sh /var/www/html/nginx/start.sh
RUN chmod +x /var/www/html/nginx/start.sh

EXPOSE 80
EXPOSE 9000

CMD ["/var/www/html/nginx/start.sh"]
