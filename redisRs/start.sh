#!/bin/bash
echo "start redis 1";
cd /redis/conf && redis-server 6380.conf
echo "start redis 2";
redis-server 6381.conf 
echo "start redis 3";
redis-server 6382.conf
