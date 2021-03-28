FROM --platform=$BUILDPLATFORM golang:alpine AS build

ARG TARGETPLATFORM
ARG BUILDPLATFORM

RUN echo "Build: $BUILDPLATFORM, target: $TARGETPLATFORM" > /log

FROM bcgdesign/alpine-s6:alpine3.12-2.0.5
COPY --from=build /log /log

ARG TARGETPLATFORM

LABEL maintainer="Ben Green <ben@bcgdesign.com>" \
    org.label-schema.name=".NET" \
    org.label-schema.version="3.1" \
    org.label-schema.vendor="Ben Green" \
    org.label-schema.schema-version="1.0"

EXPOSE 5000

ENV \
    # Must be defined so the service can run the application
    ASPNET_ASSEMBLY= \
    # Configure web servers to bind to port 5000
    ASPNETCORE_URLS="http://+:5000" \
    # Otherwise it is set incorrectly to the S6 service directory
    ASPNETCORE_CONTENTROOT="/app/live" \
    # Enable detection of running in a container
    DOTNET_RUNNING_IN_CONTAINER=true \
    # Set the invariant mode since icu_libs isn't included (see https://github.com/dotnet/announcements/issues/20)
    DOTNET_SYSTEM_GLOBALIZATION_INVARIANT=true

COPY ./overlay /
COPY ./3.1/DOTNET_REVISION /tmp/VERSION

RUN bcg-install

VOLUME [ "/app/live", "/app/publish" ]
