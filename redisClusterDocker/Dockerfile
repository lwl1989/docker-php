#centos7
FROM centos:7
#作者信息
MAINTAINER freshLi(13352019331@163.com)
#环境变量
ENV REDIS_VERSION 4.0.2

# install sshd server
RUN yum -y install openssh openssh-clients openssh-server

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
    cmake

#Add user
RUN mkdir -p /redis/data && \
    mkdir /redis/log && \
    mkdir /redis/run && \
    mkdir /redis/conf && \
    useradd -r -s /sbin/nologin -d /redis -m -k no www


#安裝redis
RUN curl -Lk http://download.redis.io/releases/redis-$REDIS_VERSION.tar.gz | gunzip | tar x -C /usr/local/src && \
    cd /usr/local/src/redis-$REDIS_VERSION && \
    make PREFIX=/usr/local/redis install && \
    cp /usr/local/src/redis-$REDIS_VERSION/src/redis-trib.rb /usr/local/redis/bin/redis-trib && \
    cp /usr/local/src/redis-$REDIS_VERSION/redis.conf /redis/conf/redis.conf && \
    sed -i 's/protected-mode yes/protected-mode no/g' /redis/conf/redis.conf && \
    sed -i 's/# cluster-enabled yes/cluster-enabled yes/g' /redis/conf/redis.conf && \
#    sed -i 's/#daemonize no/daemonize yes/g' /redis/conf/redis.conf && \
    sed -i 's/pidfile \/var\/run\/redis.pid/\/redis\/run\/redis.pid/g' /redis/conf/redis.conf && \
    sed -i 's/logfile ""/logfile \/redis\/log\/redis.log/g' /redis/conf/redis.conf && \
    ln -s /usr/local/redis/bin/redis-trib /usr/bin/redis-trib && \
    ln -s /usr/local/redis/bin/redis-server /usr/bin/redis-server && \
    chown www:www /redis -R

ADD start.sh /start.sh
RUN chmod 755 /start.sh

EXPOSE 22 6379




