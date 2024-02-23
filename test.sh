#!/bin/sh

IMAGE=alpine
VERSION=`cat VERSION`
ALPINE=${1:-3.19}
TAG=${IMAGE}-test

docker buildx build \
    --load \
    --build-arg BF_IMAGE=${IMAGE} \
    --build-arg BF_VERSION=${VERSION} \
    -f ${ALPINE}/Dockerfile \
    -t ${TAG} \
    . \
    && \
    docker run --entrypoint "/usr/bin/env" ${TAG} -i nu -c "use bf test ; test"
