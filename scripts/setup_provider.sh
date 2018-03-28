#!/bin/sh
set -e
set -x

HOME=$(cd `dirname $0`; pwd)
DEMO_ROOT=$HOME/../dubbo-demo
cd $HOME

# prepare for dubbo-provider-mesher
cp mesher dubbo-provider-mesher/

# prepare for dubbo-provider
cd $DEMO_ROOT/dubbo-demo-provider
mvn clean install
mvn dependency:copy-dependencies
sleep 2

mkdir -p $HOME/dubbo-provider/lib
cp -r target/dubbo-demo-provider-2.5.6.jar $HOME/dubbo-provider/lib
cp -r target/dependency/* $HOME/dubbo-provider/lib

# prepare for provider yaml
cd $HOME
net_name=$(ip -o -4 route show to default | awk '{print $5}')
SERVER_HOST=$(ifconfig $net_name | grep -E 'inet\W' | grep -o -E [0-9]+.[0-9]+.[0-9]+.[0-9]+ | head -n 1)
sed -i s/"serveraddress"/"$SERVER_HOST"/ provider.yaml

# start provider
docker-compose -f provider.yaml up




