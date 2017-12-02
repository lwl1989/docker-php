#使用

	docker pull li97as1/redis_cluster:5.0

	docker run --name $yourName -p $port:6379 $port+1000:16379 -d li97as1/redis_cluster:5.0 /start.sh
