#!/bin/bash

set -euo pipefail

docker pull bfren/alpine

BASE_REVISION="4.3.6"
echo "Base: ${BASE_REVISION}"

ASPNET_VERSIONS="3.1 6.0 7.0"
for V in ${ASPNET_VERSIONS} ; do

    echo "ASP.NET ${V}"
    ALPINE_MINOR=`cat ./${V}/ALPINE_MINOR`

    DOCKERFILE=$(docker run \
        -v ${PWD}:/ws \
        -e BF_DEBUG=0 \
        bfren/alpine esh \
        "/ws/Dockerfile.esh" \
        BASE_REVISION=${BASE_REVISION} \
        ALPINE_MINOR=${ALPINE_MINOR} \
        ASPNET_MINOR=${V}
    )

    echo "${DOCKERFILE}" > ./${V}/Dockerfile

done

docker system prune -f
echo "Done."
