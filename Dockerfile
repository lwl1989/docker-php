#centos7
FROM frostsky/centos-sshd:7.3
#作者信息
MAINTAINER freshLi(13352019331@163.com)
#环境变量
ENV PHP_VERSION 7.1.9
ENV REDIS_VERSION 3.2.9

#安装编译工具
RUN yum clean all && \
	set -x && \
    yum install -y gcc \    
    gcc-c++ \
    autoconf \
    automake \
    libtool \
    make \
	git \
    cmake && \

#Install PHP library
    rpm -ivh http://dl.fedoraproject.org/pub/epel/6/i386/epel-release-6-8.noarch.rpm && \
    yum install -y zlib \
    libstdc++-devel \
    zlib-devel \
    openssl \
    openssl-devel \
    pcre-devel \
    libxml2 \
    libxml2-devel \
    libcurl \
    libcurl-devel \
    libpng-devel \
    libjpeg-devel \
    freetype-devel \
    libmcrypt-devel \    
    python-setuptools \
    ImageMagick \
    ImageMagick-devel && \

#Add user
    mkdir -p /www/run && \
    mkdir -p /www/devlog && \
    touch /www/devlog/nginx_error.log && \
    touch /www/devlog/access.log && \
    touch /www/devlog/php_error.log && \
    #project dir
    mkdir -p /www/project/module/trunk && \
    mkdir /www/global && \
    mkdir /www/composer && \
    mkdir /www/framework && \

    useradd -r -s /sbin/nologin -d /www -m -k no www && \
    mkdir -p /opt/font && \
    chown www:www /www -R && \
    chown www:www /opt/font -R && \

#Download tengine & php & redis & phpredis
    cd /usr/local/src/ && \
    curl -Lk http://nginx.org/download/nginx-1.12.1.tar.gz | gunzip | tar x -C /usr/local/src && \
    curl -Lk http://php.net/distributions/php-$PHP_VERSION.tar.gz | gunzip | tar x -C /usr/local/src && \
    curl -Lk http://download.redis.io/releases/redis-$REDIS_VERSION.tar.gz | gunzip | tar x -C /usr/local/src && \
    curl -Lk http://pecl.php.net/get/redis-3.1.2.tgz | gunzip | tar x -C /usr/local/src && \
    curl -Lk http://pecl.php.net/get/imagick-3.4.3.tgz | gunzip | tar x -C /usr/local/src && \

#Install tengine
    cd /usr/local/src/nginx-1.12.1 && \
    ./configure --prefix=/usr/local/nginx \
    --user=www --group=www \
    --with-pcre \
    --with-http_ssl_module \
    --with-http_realip_module \
    --without-mail_pop3_module \
    --without-mail_imap_module \
    --with-http_gzip_static_module \
    && make && make install \

#Make install php
    && cd /usr/local/src/php-$PHP_VERSION \
    && ./configure --prefix=/usr/local/php \
    --with-config-file-path=/usr/local/php/etc \
    --with-config-file-scan-dir=/usr/local/php/etc/php.d \
    --with-fpm-user=www \
    --with-fpm-group=www \
    --with-mcrypt=/usr/include \
    --with-mysqli \
    --with-pdo-mysql \
    --with-openssl \
    --with-gd \
    --with-iconv \
    --with-zlib \
    --with-gettext \
    --with-curl \
    --with-png-dir \
    --with-jpeg-dir \
    --with-freetype-dir \
    --with-xmlrpc \
    --with-mhash \
    --enable-fpm \
    --enable-xml \
    --enable-shmop \
    --enable-sysvsem \
    --enable-inline-optimization \
    --enable-mbregex \
    --enable-mbstring \
    --enable-ftp \
    --enable-gd-native-ttf \
    --enable-mysqlnd \
    --enable-pcntl \
    --enable-sockets \
    --enable-zip \
    --enable-soap \
    --enable-session \
    --enable-opcache \
    --enable-bcmath \
    --enable-exif \
    --enable-fileinfo \
    --disable-rpath \
    --enable-ipv6 \
    --disable-debug \
    --enable-phar \
    --without-pear \
    && make && make install \

#Install php-fpm
    && cd /usr/local/src/php-$PHP_VERSION \
    && cp php.ini-production /usr/local/php/etc/php.ini \
    && cp /usr/local/php/etc/php-fpm.conf.default /usr/local/php/etc/php-fpm.conf \
    && cp /usr/local/php/etc/php-fpm.d/www.conf.default /usr/local/php/etc/php-fpm.d/www.conf \
    && cp -R ./sapi/fpm/init.d.php-fpm /etc/init.d/php-fpm && chmod +x /etc/init.d/php-fpm \
    && sed -i 's/listen = 127.0.0.1:9000/;listen = 127.0.0.1:9000\nlisten = \/www\/run\/fpm.sock/g' /usr/local/php/etc/php-fpm.d/www.conf \
    && sed -i 's/;listen.owner = www/listen.owner = www/g' /usr/local/php/etc/php-fpm.d/www.conf \
    && sed -i 's/;listen.group = www/listen.group = www/g' /usr/local/php/etc/php-fpm.d/www.conf \
    && sed -i 's/;listen.mode = 0660/listen.mode = 0660/g' /usr/local/php/etc/php-fpm.d/www.conf \


#Config php.ini
    && sed -i 's#; extension_dir = \"\.\/\"#extension_dir = "/usr/local/php/lib/php/extensions/no-debug-non-zts-20160303"#' /usr/local/php/etc/php.ini \
    && sed -i 's/post_max_size = 8M/post_max_size = 64M/g' /usr/local/php/etc/php.ini \
    && sed -i 's/upload_max_filesize = 2M/upload_max_filesize = 64M/g' /usr/local/php/etc/php.ini \
    && sed -i 's/;date.timezone =/date.timezone = UTC/g' /usr/local/php/etc/php.ini \
    && sed -i 's#;error_log = syslog#error_log = /www/devlog/php_error.log#' /usr/local/php/etc/php.ini \
    && sed -i 's/max_execution_time = 30/max_execution_time = 120/g' /usr/local/php/etc/php.ini \
    && sed -i 's/\[opcache\]/[opcache]\nzend_extension=opcache.so/g' /usr/local/php/etc/php.ini \
    && sed -i 's/;opcache.enable=1/opcache.enable=1/g' /usr/local/php/etc/php.ini \
    && sed -i 's/;opcache.enable_cli=1/opcache.enable_cli=1/g' /usr/local/php/etc/php.ini \
    && sed -i 's/;opcache.fast_shutdown=0/opcache.fast_shutdown=1/g' /usr/local/php/etc/php.ini \  

#Install PHPRedis
    && cd /usr/local/src/redis-3.1.2 \
    && /usr/local/php/bin/phpize \
    && ./configure --with-php-config=/usr/local/php/bin/php-config \
    && make && make install \
    && sed -i 's/; Windows Extensions/extension=redis.so\n; Windows Extensions/g' /usr/local/php/etc/php.ini \
#Install Apcu
	&& cd /usr/local/src \
	&& git clone https://github.com/krakjoe/apcu.git \
	&& cd apcu \
	&& /usr/local/php/bin/phpize \
	&& ./configure --with-php-config=/usr/local/php/bin/php-config \
	&& make && make install \
#Install MongoDb
	&& cd /usr/local/src \
	&& git clone https://github.com/mongodb/mongo-php-driver.git \
	&& cd mongo-php-driver \
	&& git submodule sync && git submodule update --init \
	&& /usr/local/php/bin/phpize \
	&& ./configure --with-php-config=/usr/local/php/bin/php-config \
	&& make && make install \
#Install imagick
    && cd /usr/local/src/imagick-3.4.3 \
    && /usr/local/php/bin/phpize \
    && ./configure --with-php-config=/usr/local/php/bin/php-config \
    && make && make install \
#Install swoole    
#    && curl -Lk https://codeload.github.com/swoole/swoole-src/tar.gz/v$SWOOLE_VERSION | gunzip | tar x -C /usr/local/src \
#    && cd /usr/local/src/swoole-src-$SWOOLE_VERSION \
#    && /usr/local/php/bin/phpize \
#    && ./configure --with-php-config=/usr/local/php/bin/php-config && make && make install \
#   extension=swoole.so\n
    && sed -i 's/extension=redis.so/extension=redis.so\nextension=imagick.so\nextension=mongodb.so\nextension=apcu.so\napc.enable_cli=1/g' /usr/local/php/etc/php.ini \

#Clean OS
    && yum remove -y gcc \
    gcc-c++ \
    autoconf \
    automake \
    libtool \
    make \
    cmake \
    && yum clean all \
    && rm -rf /tmp/* /var/cache/{yum,ldconfig} /etc/my.cnf{,.d} \
    && mkdir -p --mode=0755 /var/cache/{yum,ldconfig} \
    && find /var/log -type f -delete \
    && rm -rf /usr/local/src/* \

#Change Mod from webdir
    && chown -R www:www /www

#Create web folder
VOLUME ["/www"]

ADD index.php /www/

#Update nginx config
ADD nginx.conf /usr/local/nginx/conf/

ADD NotoSansCJKtc-Medium.otf /opt/font/

#Start
ADD start.sh /start.sh
RUN chmod 755 /start.sh

#Set port
EXPOSE 22 80 443
#6379

#Start it
#ENTRYPOINT ["/start.sh"]

#Start web server
#CMD ["/start.sh"]


#run command
#docker run -p 9999:80 -v /www/smart/app/global:/www/global -v /www/smart/app/composer:/www/composer -v /www/smart/app/framework:/www/framework -v /www/smart/app/project/manager/trunk:/www/project/module/trunk --name t1 lwl/iloc:0.0.2
