#!/bin/bash
echo Y | apt-get update
echo Y | apt-get install python
echo Y | apt-get install docker.io
echo hello >> test
sleep 5
docker login -e jeremiah.gearheart@pearson.com -u _json_key -p "$(cat gcrtest.json)" https://gcr.io
docker pull gcr.io/pearson-techops/cosmos/vrouter:latest
sleep 10
docker run --net host --privileged --name vrouter -itd gcr.io/pearson-techops/cosmos/vrouter:latest
