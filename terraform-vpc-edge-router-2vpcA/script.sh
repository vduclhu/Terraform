#!/bin/bash
echo Y | apt-get update
echo Y | apt-get install python
echo Y | apt-get install docker.io
echo ${aws_security_group.cosmos-vrouter.id} >> test
sleep 5
docker login -e jeremiah.gearheart@pearson.com -u _json_key -p "$(cat gcrtest.json)" https://gcr.io
docker pull gcr.io/pearson-techops/cosmos/vrouter:latest
sleep 10
docker run -itd --restart always --privileged --net host --name vrouter -e ETCDCTL_PEERS=http://a9a237292257111e799a206666ed500c-845781772.us-east-2.elb.amazonaws.com:2379  gcr.io/pearson-techops/cosmos/vrouter:latest
