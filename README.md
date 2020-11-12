# Docker ASP.NET

![build](https://github.com/bencgreen/docker-aspnet/workflows/build/badge.svg)

[Docker Repository](https://hub.docker.com/r/bcgdesign/aspnet)

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
