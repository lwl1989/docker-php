#centos7
FROM centos:7
#作者信息
MAINTAINER freshLi(13352019331@163.com)

#RUN setenforce 0

ADD mongodb-org-3.4.repo  /etc/yum.repos.d/mongodb-org-3.4.repo 

RUN yum update -y

RUN yum install mongodb-org  -y

RUN mkdir /data

RUN mkdir /conf

ADD 27018.conf /conf/27018.conf 
ADD 27019.conf /conf/27019.conf
ADD 27020.conf /conf/27020.conf

RUN mkdir /start
ADD start.sh /start/start.sh

ADD initRs.js /start/initRs.js

RUN chmod +x /start/start.sh

EXPOSE 27018 27019 27020

CMD ["/start/start.sh"]
