FROM bcgdesign/alpine-s6:1.0.3

LABEL maintainer="Ben Green <ben@bcgdesign.com>" \
    org.label-schema.name=".NET" \
    org.label-schema.version="latest" \
    org.label-schema.vendor="Ben Green" \
    org.label-schema.schema-version="1.0"

# https://github.com/dotnet/dotnet-docker/blob/master/src/runtime-deps/3.1/alpine3.12/amd64/Dockerfile
RUN apk update \
    && apk upgrade \
    && apk add \
        ca-certificates \
        krb5-libs \
        libgcc \
        libintl \
        libssl1.1 \
        libstdc++ \
        zlib

ENV \
    # Configure web servers to bind to port 80 when present
    ASPNETCORE_URLS=http://+:80 \
    # Enable detection of running in a container
    DOTNET_RUNNING_IN_CONTAINER=true \
    # Set the invariant mode since icu_libs isn't included (see https://github.com/dotnet/announcements/issues/20)
    DOTNET_SYSTEM_GLOBALIZATION_INVARIANT=true

ENV DOTNET_VERSION=5.0.0

# https://github.com/dotnet/dotnet-docker/blob/master/src/runtime/5.0/alpine3.12/amd64/Dockerfile
RUN wget -O dotnet.tar.gz https://dotnetcli.azureedge.net/dotnet/Runtime/${DOTNET_VERSION}/dotnet-runtime-${DOTNET_VERSION}-linux-musl-x64.tar.gz \
    && dotnet_sha512='c112bdc4308c0b49fa4f4f9845bf13bfcfe2debed9166e6e6922f389c043d6f7f55a7cc3e03778c08df3ffd415059b90dfb87ce84c95a0fb1de0a6e9f4428b6f' \
    && echo "$dotnet_sha512  dotnet.tar.gz" | sha512sum -c - \
    && mkdir -p /usr/share/dotnet \
    && tar -C /usr/share/dotnet -oxzf dotnet.tar.gz \
    && ln -s /usr/share/dotnet/dotnet /usr/bin/dotnet \
    && rm dotnet.tar.gz

ENV ASPNET_VERSION=${DOTNET_VERSION}

# https://github.com/dotnet/dotnet-docker/blob/master/src/aspnet/5.0/alpine3.12/amd64/Dockerfile
RUN wget -O aspnetcore.tar.gz https://dotnetcli.azureedge.net/dotnet/aspnetcore/Runtime/${ASPNET_VERSION}/aspnetcore-runtime-${ASPNET_VERSION}-linux-musl-x64.tar.gz \
    && aspnetcore_sha512='1f36800145889f6e8dd823deffce309094d35c646e231fd36fa488c83df76db7b6166eea1d50db0513e0730ca33540cb081f7675ea255135e4e553e7aa5ef2ce' \
    && echo "$aspnetcore_sha512  aspnetcore.tar.gz" | sha512sum -c - \
    && tar -ozxf aspnetcore.tar.gz -C /usr/share/dotnet ./shared/Microsoft.AspNetCore.App \
    && rm aspnetcore.tar.gz

RUN addgroup --gid 1000 www \
    && adduser --uid 1000 --no-create-home --disabled-password --ingroup www www \
    && rm -rf /var/cache/apk/*

COPY ./overlay /

VOLUME [ "/src" ]

RUN chmod +x /usr/bin/healthcheck
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=5 CMD [ "/usr/bin/healthcheck" ]
