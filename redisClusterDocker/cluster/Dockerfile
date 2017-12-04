FROM redis:4.0.5

MAINTAINER freshLi(13352019331@163.com)

RUN mkdir -p /redis

ADD 6380 /redis/6380
ADD 6381 /redis/6381
ADD 6382 /redis/6382
ADD start.sh /start.sh
RUN chmod 755 /start.sh

expose 6380 6381 6382
cmd ["/start.sh"]
