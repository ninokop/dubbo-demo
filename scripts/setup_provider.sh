#!/bin/sh
set -e
set -x

HOME=$(cd `dirname $0`; pwd)
cd $HOME

# prepare for dubbo-provider-mesher
cp mesher dubbo-provider-mesher/

# prepare for dubbo-provider

# prepare for provider yaml
net_name=$(ip -o -4 route show to default | awk '{print $5}')
SERVER_HOST=$(ifconfig $net_name | grep -E 'inet\W' | grep -o -E [0-9]+.[0-9]+.[0-9]+.[0-9]+ | head -n 1)
sed -i s/"serveraddress"/"$SERVER_HOST"/ provider.yml







