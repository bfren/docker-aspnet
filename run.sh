#!/bin/sh

IMAGE=`cat VERSION`
ASPNET=${1:-10}

docker buildx build \
    --load \
    --build-arg BF_IMAGE=aspnet \
    --build-arg BF_VERSION=${IMAGE} \
    -f ${ASPNET}/Dockerfile \
    -t aspnet${ASPNET}-dev \
    . \
    && \
    docker run -it \
        -e BF_DEBUG=1 \
        -e BF_ASPNET_ASSEMBLY=bf.bfren_dev.dll \
        -p "5000:5000" \
        -v /home/bcg/docker/aspnet/v/live:/app/live \
        aspnet${ASPNET}-dev \
        sh
