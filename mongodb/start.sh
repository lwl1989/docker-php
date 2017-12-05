#!/bin/bash


read -p "输入项目名" name
read -p "输入端口区间(27018-27020)" port
read -p "输入端口尾端" endport
if [ -z $port ]
then
	port=27018
	endport=27020
fi

sudo docker run --name $name -v /Users/limars/www/docker-php/mongodb/data:/data -p $port-$endport:27018-27020 -d li97as1/mrs:1.0

echo "docker running"

read -p "是否采用rs" rs

if [ "y" == "$rs" ]
then 
	sudo docker exec -d $name mongo --port /start/initRs.js
fi

echo "success"
