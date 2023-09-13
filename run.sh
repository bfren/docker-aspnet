#!/bin/sh

IMAGE=`cat VERSION`
ASPNET=${1:-6.0}

docker buildx build \
    --load \
    --build-arg BF_IMAGE=aspnet \
    --build-arg BF_VERSION=${IMAGE} \
    -f ${ASPNET}/Dockerfile \
    -t aspnet${ASPNET}-dev \
    . \
    && \
    docker run -it aspnet${ASPNET}-dev sh
