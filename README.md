# Docker ASP.NET

![GitHub release (latest by date)](https://img.shields.io/github/v/release/bfren/docker-aspnet) ![Docker Pulls](https://img.shields.io/docker/pulls/bfren/aspnet?label=pulls) ![Docker Image Size (tag)](https://img.shields.io/docker/image-size/bfren/aspnet/latest?label=size)<br/>
![GitHub Workflow Status](https://img.shields.io/github/workflow/status/bfren/docker-aspnet/dev-3_1?label=.NET+Core+3.1) ![GitHub Workflow Status](https://img.shields.io/github/workflow/status/bfren/docker-aspnet/dev-5_0?label=.NET+Core+5.0) ![GitHub Workflow Status](https://img.shields.io/github/workflow/status/bfren/docker-aspnet/dev-6_0?label=.NET+6.0)

[Docker Repository](https://hub.docker.com/r/bfren/aspnet) - [bfren ecosystem](https://github.com/bfren/docker)

Comes pre-installed with the ASP.NET runtime and all dependencies.

## Contents

* [Ports](#ports)
* [Volumes](#volumes)
* [Environment Variables](#environment-variables)
* [Helper Functions](#helper-functions)
* [Licence / Copyright](#licence)

## Ports

* 5000

## Volumes

| Volume      | Purpose                                  |
| ----------- | ---------------------------------------- |
| `/app/live` | Publish your source code to this folder. |

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

## Licence

> [MIT](https://mit.bfren.uk/2020)

## Copyright

> Copyright (c) 2021 bfren.uk
> Unless otherwise stated
