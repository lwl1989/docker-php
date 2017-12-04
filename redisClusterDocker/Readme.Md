#使用

	docker pull li97as1/redis_cluster:5.0

	#docker run --name $yourName --net=host -v $path/redis:/redis -d li97as1/redis_cluster:5.0 /start.sh

	cp -r ./port/6380 ./port/$port
	sed -i '' 's/127.0.0.1/0.0.0.0/g' ./port/$port/redis/conf/redis.conf	

	docker run --name $port --net=host -v ./port/$port/redis:/redis -d li97as1/redis_cluster:5.0 /start.sh
