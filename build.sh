#! /bin/bash

docker build -t ding-image .

container_id=$(docker create ding-image)
docker cp ${container_id}:/app/ding.tar.gz ding.tar.gz
docker rm ${container_id}
docker rmi ding-image