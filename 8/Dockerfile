FROM --platform=$BUILDPLATFORM golang:alpine AS build

ARG TARGETPLATFORM
ARG BUILDPLATFORM

RUN echo "Build: $BUILDPLATFORM, target: $TARGETPLATFORM" > /log

FROM bfren/alpine-s6:alpine3.18-4.5.5
COPY --from=build /log /log

LABEL org.opencontainers.image.source="https://github.com/bfren/docker-aspnet"

ARG TARGETPLATFORM

ARG BF_IMAGE
ARG BF_VERSION

EXPOSE 5000

ENV \
    # The ASP.NET version - used to assist in calculating checksums
    ASPNET_VERSION=8 \
    # Must be defined so the service can run the application
    ASPNET_ASSEMBLY= \
    # Configure web servers to bind to port 5000
    ASPNETCORE_URLS="http://+:5000" \
    # Otherwise it is set incorrectly to the S6 service directory
    DOTNET_CONTENTROOT="/app/live" \
    # Enable detection of running in a container
    DOTNET_RUNNING_IN_CONTAINER=true \
    # Set the invariant mode to false so CultureInfo can be used
    DOTNET_SYSTEM_GLOBALIZATION_INVARIANT=false

COPY ./overlay /
COPY ./8/overlay /

RUN bf-install

VOLUME [ "/app/live", "/app/publish" ]
