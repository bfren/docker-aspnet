# Docker ASP.NET

![Docker Image Version (tag latest semver)](https://img.shields.io/docker/v/bcgdesign/aspnet/latest?label=latest) ![GitHub Workflow Status](https://img.shields.io/github/workflow/status/bencgreen/docker-aspnet/3.1-dev?label=github+3.1) ![GitHub Workflow Status](https://img.shields.io/github/workflow/status/bencgreen/docker-aspnet/5.0-dev?label=github+5.0) ![Docker Cloud Build Status](https://img.shields.io/docker/cloud/build/bcgdesign/aspnet?label=docker) ![Docker Pulls](https://img.shields.io/docker/pulls/bcgdesign/aspnet?label=pulls) ![Docker Image Size (tag)](https://img.shields.io/docker/image-size/bcgdesign/aspnet/latest?label=size)

[Docker Repository](https://hub.docker.com/r/bcgdesign/aspnet) - [bcg|design ecosystem](https://github.com/bencgreen/docker)

Comes pre-installed with the ASP.NET runtime and all dependencies.

## Ports

* 80

## Environment Variables

The following is required, or `dotnet run` will not succeed:

```bash
DOTNET_RUN_ASSEMBLY= # this must be set to your starting assembly dll, relative to /src
```

The following variables modify the ASP.NET environment:

```bash
ASPNETCORE_URLS="http://+:80" # binds web server to port 80
DOTNET_RUNNING_IN_CONTAINER=true
DOTNET_SYSTEM_GLOBALIZATION_INVARIANT=true
```

## Volumes

* `/src` - the command `dotnet run` will be executed in this folder

## Authors

* [Ben Green](https://github.com/bencgreen)

## License

> MIT

## Copyright

> Copyright (c) 2020 Ben Green <https://bcgdesign.com>  
> Unless otherwise stated
