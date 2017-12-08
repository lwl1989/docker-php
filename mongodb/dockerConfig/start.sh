#!/bin/bash

echo 'starting!'
mongod -f /conf/27019.conf && \
mongod -f /conf/27018.conf && \
mongod -f /conf/27020.conf
