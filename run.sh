#!/bin/sh

IMAGE=`cat VERSION`
ASPNET=${1:-7}

docker buildx build \
    --load \
    --no-cache \
    --progress plain \
    --build-arg BF_IMAGE=aspnet \
    --build-arg BF_VERSION=${IMAGE} \
    -f ${ASPNET}/Dockerfile \
    -t aspnet${ASPNET}-dev \
    . \
    && \
    docker run -it -e BF_ASPNET_ASSEMBLY=does/not/exist.dll aspnet${ASPNET}-dev sh
