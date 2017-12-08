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

RUN mkdir -p /redis/logs && \
    mkdir /redis/run && \
    mkdir /redis/conf 


#安裝redis
RUN curl -Lk http://download.redis.io/releases/redis-$REDIS_VERSION.tar.gz | gunzip | tar x -C /usr/local/src && \
    cd /usr/local/src/redis-$REDIS_VERSION && \
    make PREFIX=/usr/local/redis install && \
    ln -s /usr/local/redis/bin/redis-cli /usr/bin/redis-cli && \
    ln -s /usr/local/redis/bin/redis-server /usr/bin/redis-server 

RUN yum remove -y gcc \
    gcc-c++ \
    autoconf \
    automake \
    libtool \
    make \
    cmake \
    && yum clean all

ADD start.sh /start.sh
RUN chmod 755 /start.sh

EXPOSE 6380 6381 6382

CMD ["/start.sh"]



