FROM li97as1/redis_cluster:6.0

MAINTAINER freshLi(13352019331@163.com)

RUN mkdir -p /redis


RUN  yum install gcc-c++ patch readline readline-devel zlib zlib-devel -y 
RUN yum install libyaml-devel libffi-devel openssl-devel make -y
RUN yum install which bzip2 autoconf automake libtool bison iconv-devel sqlite-devel -y 


RUN curl -sSL https://rvm.io/mpapis.asc | gpg --import - 
RUN curl -L get.rvm.io | bash -s stable
RUN source /etc/profile.d/rvm.sh
#RUN rvm reload
RUN /usr/local/rvm/bin/rvm install 2.4.1
RUN ln -s /usr/local/rvm/rubies/ruby-2.4.1/bin/ruby /usr/bin/ruby
RUN ln -s /usr/local/rvm/rubies/ruby-2.4.1/bin/gem /usr/bin/gem 
RUN gem install redis

ADD 6380 /redis/6380
ADD 6381 /redis/6381
ADD 6382 /redis/6382


ADD start.sh /start.sh
RUN chmod 755 /start.sh

expose 6380 6381 6382 16380 16381 16382
cmd ["/start.sh"]
