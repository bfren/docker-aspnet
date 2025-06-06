#!/bin/bash

set -euo pipefail

docker pull bfren/alpine

BASE_VERSION="5.6.2"
echo "Base: ${BASE_VERSION}"

ASPNET_VERSIONS="6 7 8 9 10"
for V in ${ASPNET_VERSIONS} ; do

    echo "ASP.NET ${V}"
    ALPINE_MINOR=`cat ./${V}/ALPINE_MINOR`

    DOCKERFILE=$(docker run \
        -v ${PWD}:/ws \
        -e BF_DEBUG=0 \
        bfren/alpine esh \
        "/ws/Dockerfile.esh" \
        BASE_VERSION=${BASE_VERSION} \
        ALPINE_MINOR=${ALPINE_MINOR} \
        ASPNET_VERSION=${V}
    )

    echo "${DOCKERFILE}" > ./${V}/Dockerfile

done

docker system prune -f
echo "Done."
