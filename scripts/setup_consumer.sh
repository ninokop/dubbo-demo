#!/bin/sh
set -e
set -x

HOME=$(cd `dirname $0`; pwd)
DEMO_ROOT=$HOME/../dubbo-demo
cd $HOME

# prepare for dubbo-consumer-mesher
cp mesher dubbo-consumer-mesher/

# prepare for dubbo-consumer
cd $DEMO_ROOT/dubbo-demo-consumer
mvn clean install
mvn dependency:copy-dependencies
sleep 2

mkdir -p $HOME/dubbo-consumer/lib
cp -r target/dubbo-demo-consumer-2.5.6.jar $HOME/dubbo-consumer/lib
cp -r target/dependency/* $HOME/dubbo-consumer/lib

# prepare for consumer yaml
cd $HOME
net_name=$(ip -o -4 route show to default | awk '{print $5}')
SERVER_HOST=$(ifconfig $net_name | grep -E 'inet\W' | grep -o -E [0-9]+.[0-9]+.[0-9]+.[0-9]+ | head -n 1)
sed -i s/"serveraddress"/"$SERVER_HOST"/ consumer.yaml

# start consumer
# docker-compose -f consumer.yaml up