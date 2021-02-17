# Docker ASP.NET

![GitHub release (latest by date)](https://img.shields.io/github/v/release/bencgreen/docker-aspnet) ![GitHub Workflow Status](https://img.shields.io/github/workflow/status/bencgreen/docker-aspnet/3.1-dev?label=github+3.1) ![GitHub Workflow Status](https://img.shields.io/github/workflow/status/bencgreen/docker-aspnet/5.0-dev?label=github+5.0) ![Docker Cloud Build Status](https://img.shields.io/docker/cloud/build/bcgdesign/aspnet?label=docker) ![Docker Pulls](https://img.shields.io/docker/pulls/bcgdesign/aspnet?label=pulls) ![Docker Image Size (tag)](https://img.shields.io/docker/image-size/bcgdesign/aspnet/latest?label=size)

[Docker Repository](https://hub.docker.com/r/bcgdesign/aspnet) - [bcg|design ecosystem](https://github.com/bencgreen/docker)

Comes pre-installed with the ASP.NET runtime and all dependencies.

## Contents

* [Ports](#ports)
* [Volumes](#volumes)
* [Environment Variables](#environment-variables)
* [Helper Functions](#helper-functions)
* [Authors / Licence / Copyright](#authors)

## Ports

* 80

## Volumes

| Volume | Purpose                                  |
| ------ | ---------------------------------------- |
| `/src` | Publish your source code to this folder. |

## Environment Variables

| Variable                                | Values        | Description                                                                                                                                                                   | Default               |
| --------------------------------------- | ------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | --------------------- |
| `ASPNET_ASSEMBLY`                       | string        | The filename of the assembly to execute.                                                                                                                                      | *None* - **required** |
| `ASPNETCORE_URLS`                       | string        | Default value binds web server to port 5000 - should not normally need to be changed.                                                                                         | "http://+:5000"       |
| `DOTNET_RUNNING_IN_CONTAINER`           | true or false | This should always be set to true - it tells dotnet that it is running in a container environment.                                                                            | true                  |
| `DOTNET_SYSTEM_GLOBALIZATION_INVARIANT` | true or false | See [here](https://github.com/dotnet/runtime/blob/master/docs/design/features/globalization-invariant-mode.md) and [here](https://github.com/dotnet/announcements/issues/20). | true                  |

## Helper Functions

| Function     | Arguments | Description                                                                             |
| ------------ | --------- | --------------------------------------------------------------------------------------- |
| `dotnet-run` | *None*    | Checks that the `DOTNET_RUN_ASSEMBLY` environment variable is set and then executes it. |

## Authors

* [Ben Green](https://github.com/bencgreen)

## License

> MIT

## Copyright

> Copyright (c) 2021 Ben Green <https://bcgdesign.com>
> Unless otherwise stated
