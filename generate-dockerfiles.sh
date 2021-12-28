#!/bin/bash

set -euo pipefail

docker pull bfren/alpine

BASE_REVISION="3.2.2"
echo "Base: ${BASE_REVISION}"

ASPNET_VERSIONS="3.1 5.0 6.0"
for V in ${ASPNET_VERSIONS} ; do

    echo "ASP.NET ${V}"
    ALPINE_MINOR=`cat ./${V}/ALPINE_MINOR`

    DOCKERFILE=$(docker run \
        -v ${PWD}:/ws \
        bfren/alpine esh \
        "/ws/Dockerfile.esh" \
        BASE_REVISION=${BASE_REVISION} \
        ALPINE_MINOR=${ALPINE_MINOR} \
        ASPNET_MINOR=${V}
    )

    echo "${DOCKERFILE}" > ./${V}/Dockerfile

done

echo "Done."
