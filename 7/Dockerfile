FROM ghcr.io/bfren/alpine-s6:alpine3.19-5.4.7

LABEL org.opencontainers.image.source="https://github.com/bfren/docker-aspnet"

ARG BF_IMAGE
ARG BF_PUBLISHING
ARG BF_VERSION

EXPOSE 5000

COPY ./overlay /
COPY ./7/overlay /

ENV \
    # The ASP.NET version - used to assist in calculating checksums
    ASPNET_VERSION=7 \
    # Configure web servers to bind to port 5000
    ASPNETCORE_URLS="http://+:5000" \
    # Must be defined so the service can run the application
    BF_ASPNET_ASSEMBLY= \
    # Otherwise it is set incorrectly to the S6 service directory
    DOTNET_CONTENTROOT="/app/live" \
    # Enable detection of running in a container
    DOTNET_RUNNING_IN_CONTAINER=true \
    # Set the invariant mode to false so CultureInfo can be used
    DOTNET_SYSTEM_GLOBALIZATION_INVARIANT=false

RUN bf-install

VOLUME [ "/app/live", "/app/publish" ]
