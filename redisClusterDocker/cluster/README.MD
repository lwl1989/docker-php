#ruby版本 2.2.2

#redis需要開放 +10000端口


#redis cluster 不支持橋接

#怎麼辦 查

發現神器
	docker swarm 
docker swarm init  默認本機2377端口
docker swarm join-token manager  //加入管理員
docker swarm join-token xas  //生成了token 子節點加入

dockerfile重寫 
 docker network create --driver overlay net1
編譯rvm的問題

#開啓服務 按需開放端口
docker service create --name ceshi_master -p 6380-6389:6380-6389 -p 16380-16389:16380-16389 --replicas 3 --network net1 li97as1/redis_cluster:2.0
docker service create --name ceshi_slave -p 6390-6399:6380-6389 -p 16390-16399:16380-16389 --replicas 3 --network net1 li97as1/redis_cluster:2.0
每個服務必須是一樣的鏡像 不能把redis-trib單獨列出去
create service 追加運行參數  後臺運行等問題

#列出Ip
docker network inspect net1
記錄IP
#進入其中一個docker
redis-trib create 10.0.0.3:6380 10.0.0.3:6381 10.0.0.3:6382 10.0.0.9:6380 10.0.0.9:6381 10.0.0.9:6382
