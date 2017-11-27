#!/bin/bash
read -p "enter redis port:" port1
read -p "enter redis port:" port2
read -p "enter redis port:" port3
projectName='redis_'${port}
read -p "enter host1:" host1
read -p "enter host2:" host2
read -p "enter host3:" host3
read -p "enter replicas:" replicas

#sudo docker exec $projectName yum install -y ruby rubygems
#sudo docker exec $projectName redis-trib create --replicas $replicas $host1:$port1 $host1:$port2 $host1:$port3 && \
#$host2:$port1 $host2:$port2 $host2:$port3 && \
#$host3:$port1 $host3:$port2 $host3:$port3


sudo yum install -y ruby rubygems


