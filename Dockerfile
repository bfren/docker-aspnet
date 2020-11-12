FROM --platform=$BUILDPLATFORM golang:alpine AS build

ARG TARGETPLATFORM
ARG BUILDPLATFORM

RUN echo "Build: $BUILDPLATFORM, target: $TARGETPLATFORM" > /log

FROM bcgdesign/alpine-s6:1.0.3

LABEL maintainer="Ben Green <ben@bcgdesign.com>" \
    org.label-schema.name=".NET" \
    org.label-schema.version="latest" \
    org.label-schema.vendor="Ben Green" \
    org.label-schema.schema-version="1.0"

ENV PORT=5000

RUN addgroup --gid 1000 www \
    && adduser --uid 1000 --no-create-home --disabled-password --ingroup www www \
    && apk update \
    && apk upgrade \
    && apk add \
        icu-libs \
        krb5-libs \
        libgcc \
        libintl \
        libssl1.1 \
        libstdc++ \
        zlib \
    && rm -rf /var/cache/apk/* /tmp/*
    
ARG TARGETPLATFORM
ARG DOTNET_VERSION=5.0.0

COPY ./DOTNET_MINOR /tmp/DOTNET_MINOR
COPY ./install /tmp/install
RUN export CHANNEL=$(cat /tmp/DOTNET_MINOR) \
    && echo "ASP.NET v${CHANNEL}" \
    && apk add --no-cache --virtual .install curl \
    && chmod +x /tmp/install \
    && /tmp/install \
    && rm /tmp/install \
    && apk del --no-cache .install

COPY ./overlay /

VOLUME [ "/src" ]

RUN chmod +x /usr/bin/healthcheck
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=5 CMD [ "/usr/bin/healthcheck" ]
