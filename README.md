# ASP.NET

![GitHub release (latest by date)](https://img.shields.io/github/v/release/bfren/docker-aspnet) ![Docker Pulls](https://img.shields.io/endpoint?url=https%3A%2F%2Fbfren.dev%2Fdocker%2Fpulls%2Faspnet) ![Docker Image Size](https://img.shields.io/endpoint?url=https%3A%2F%2Fbfren.dev%2Fdocker%2Fsize%2Faspnet) ![GitHub Workflow Status](https://img.shields.io/github/actions/workflow/status/bfren/docker-aspnet/build.yml?branch=main)

[Docker Hub](https://hub.docker.com/r/bfren/aspnet) - [Quay.io](https://quay.io/repository/bfren/aspnet) - [bfren ecosystem](https://github.com/bfren/docker)

## Introduction

An image for running a published [ASP.NET Core](https://dotnet.microsoft.com/apps/aspnet) application, supervised by S6, with a simple way to deploy new versions without rebuilding the image.

It is [Alpine + S6](https://github.com/bfren/docker-alpine-s6) with:

* the .NET and ASP.NET Core runtimes (the musl builds from Microsoft, checked against their SHA-512 hashes), for .NET 8, 9, 10 and 11
* an `aspnet` service that runs your application as the non-root `www` user
* two application folders - `live` and `publish` - so you can upload a new version and switch to it, and switch back if it goes wrong
* a daily application restart and a health check

It only contains the runtimes, not the SDK - build and publish your application elsewhere (`dotnet publish`), then run the output here. There is no SSL support - it is designed to run behind a reverse proxy such as [Caddy](https://github.com/bfren/docker-caddy-proxy).

## Quickstart

Publish your application, then run it from `./publish`:

```sh
dotnet publish -c Release -o ./publish
docker run -d --name app -p 5000:5000 \
    -e BF_ASPNET_ASSEMBLY=MyApp.dll \
    -v ./publish:/app/live \
    quay.io/bfren/aspnet:net10
```

Or with Docker Compose:

```yaml
services:
  app:
    image: quay.io/bfren/aspnet:net10-7.0
    environment:
      - BF_ASPNET_ASSEMBLY=MyApp.dll
    ports:
      - "5000:5000"
    volumes:
      - ./v/live:/app/live
      - ./v/publish:/app/publish
```

Open `http://localhost:5000`. `BF_ASPNET_ASSEMBLY` is the file name of your application's main `.dll`, inside `/app/live`.

## Features

* 🟣 .NET 8, 9, 10 and 11 - choose with the image tag
* 🔁 Deploy without rebuilding: upload to `/app/publish`, then `aspnet-switch` - and switch again to roll back
* 👤 The application runs as the non-root `www` user, with its files read-only
* ⏳ Waits for your application: if the assembly isn't there yet, the service checks again every 30 seconds instead of stopping the container
* 🔄 Application restarted every day at 02:00
* 🩺 Health check that loads the application's home page
* 🌍 Globalisation enabled (ICU is installed) for `en-US` and `en-GB` - see [Globalisation](#globalisation) for other cultures
* 🕐 Time zone data installed, so `TimeZoneInfo` can convert between time zones

## Tags

Images are published to Docker Hub (`bfren/aspnet`) and Quay.io (`quay.io/bfren/aspnet`) for `linux/amd64`, `linux/arm/v7` and `linux/arm64`. Tags start with the .NET version.

| Tag            | Example       | Use when                                              |
| -------------- | ------------- | ----------------------------------------------------- |
| `netX`         | `net10`       | You want the latest image for a .NET version          |
| `netX-MAJOR`   | `net10-7`     | You want updates, but not breaking changes            |
| `netX-MINOR`   | `net10-7.0`   | You want fixes only - **recommended for building on** |
| `netX-VERSION` | `net10-7.0.0` | You want to pin this image exactly                    |
| `netX.Y.Z`     | `net10.0.14`  | You want an exact .NET runtime release                |

There is no `latest` tag - always choose a .NET version.

| .NET | Runtime     | Type              | Alpine | Microsoft support ends |
| ---- | ----------- | ----------------- | ------ | ---------------------- |
| 11   | 11.0.0-rc.3 | Release candidate | 3.24   | n/a - not yet released |
| 10   | 10.0.14     | Long-term support | 3.24   | 2028-11-14             |
| 9    | 9.0.22      | Standard support  | 3.24   | 2026-11-10             |
| 8    | 8.0.33      | Long-term support | 3.24   | 2026-11-10             |

.NET 8 and 9 both reach the end of support in November 2026 - use .NET 10 for anything new, and don't use .NET 11 in production until it is released. [Source: .NET Support Policy](https://dotnet.microsoft.com/platform/support/policy)

## Configuration

### Ports

| Port   | Purpose                                                                  |
| ------ | ------------------------------------------------------------------------ |
| `5000` | HTTP - your application (set by `ASPNETCORE_URLS`). Use a proxy for SSL. |

### Volumes

| Volume         | Purpose                                                                                |
| -------------- | -------------------------------------------------------------------------------------- |
| `/app/live`    | The application that is running.                                                       |
| `/app/publish` | Upload a new version here, then run `aspnet-switch`. Holds the previous version after. |

### Environment Variables

| Variable                                | Values          | Description                                                                       | Default         |
| --------------------------------------- | --------------- | --------------------------------------------------------------------------------- | --------------- |
| `BF_ASPNET_ASSEMBLY`                    | file name       | **Required.** Your application's main `.dll`, relative to `/app/live`.            | *blank*         |
| `ASPNETCORE_URLS`                       | URL             | Where the application listens. The health check uses it too - keep it to one URL. | `http://+:5000` |
| `DOTNET_CONTENTROOT`                    | path            | The application's content root.                                                   | `/app/live`     |
| `DOTNET_SYSTEM_GLOBALIZATION_INVARIANT` | `true`, `false` | Set to `true` to turn off globalisation support.                                  | `false`         |
| `DOTNET_RUNNING_IN_CONTAINER`           | `true`          | Tells .NET it is running in a container.                                          | `true`          |
| `BF_DEBUG`                              | `0`, `1`        | Show detailed output from `bf` scripts.                                           | `0`             |

Alpine + S6 adds [more variables](https://github.com/bfren/docker-alpine-s6#environment-variables) (timezone, cron).

## How It Works

### Starting

When the container starts, [Alpine + S6](https://github.com/bfren/docker-alpine-s6#starting) runs the initialisation scripts. This image adds two: `10-env` sets the application paths, and `11-version` checks the ASP.NET runtime and shows its version. Then S6 starts the `aspnet` service, which runs `dotnet /app/live/$BF_ASPNET_ASSEMBLY` as the `www` user.

If the assembly doesn't exist yet, the service says so, waits 30 seconds and exits - S6 then starts it again. So you can start the container first and publish your application afterwards. Unlike most images in the ecosystem, the container does **not** stop when the application fails - S6 restarts it.

### Globalisation

Globalisation is on (`DOTNET_SYSTEM_GLOBALIZATION_INVARIANT=false`), so .NET uses ICU for cultures, sorting and formatting. Alpine's `icu-libs` comes with `icu-data-en`, which only contains the `en-US` and `en-GB` locales. Other cultures (e.g. `fr-FR`) don't cause an error - formatting and sorting quietly fall back to the default data instead.

If your application needs other cultures, add Alpine's full ICU data in your own image - it adds about 32 MB:

```dockerfile
RUN apk add --no-cache icu-data-full
```

### Time zones

`tzdata` is installed, so `TimeZoneInfo.FindSystemTimeZoneById("Europe/London")` and other IANA time zones work. The container's own time zone is set by `BF_TZ` (default `Europe/London`).

### Permissions

At start-up, and after every switch, ownership and permissions are applied:

| Folder         | Owner     | Files  | Folders |
| -------------- | --------- | ------ | ------- |
| `/app/live`    | `www:www` | `0400` | `0500`  |
| `/app/publish` | `www:www` | `0600` | `0700`  |

Your application can read its own files but not change them. Store anything it writes (uploads, logs, data protection keys) in another volume.

### Deploying a new version

1. Copy the output of `dotnet publish` into `/app/publish` (on the host, the folder mounted there).
2. Run `docker exec <container> aspnet-switch`.

`aspnet-switch` swaps the two folders - the new version moves to `/app/live`, the old one to `/app/publish` - re-applies the permissions, and restarts the application. To roll back, run `aspnet-switch` again.

`aspnet-switch-terminate` does the same swap, then stops the container instead of restarting the application, so your restart policy (e.g. `restart: unless-stopped`) starts it again cleanly.

### Restarting

`aspnet-restart` stops the `aspnet` service, stops any remaining `dotnet` processes, then starts the service again. It runs automatically every day at 02:00, and you can run it yourself:

```sh
docker exec <container> aspnet-restart
```

### Health check

The health check (`/etc/bf/health.d/10-aspnet.nu`) loads `ASPNETCORE_URLS` (with `+` replaced by `localhost`, so `http://localhost:5000` by default) and passes if the HTTP status is between 200 and 399. Docker runs it every 30 seconds (every 2 seconds during the first 60 seconds). If your application doesn't answer at `/` - an API, for example - replace `/etc/bf/health.d/10-aspnet.nu` in your own image.

### The `bf-aspnet` module

| Command                 | Use                                                                                      |
| ----------------------- | ---------------------------------------------------------------------------------------- |
| `bf-aspnet app disable` | Stop the `aspnet` service and any `dotnet` processes.                                    |
| `bf-aspnet app restart` | Stop, then start the application again (used by `aspnet-restart`).                       |
| `bf-aspnet app switch`  | Swap `/app/publish` and `/app/live`. Add `--terminate` to stop the container afterwards. |

The helpers on the `PATH` are `aspnet-restart`, `aspnet-switch` and `aspnet-switch-terminate`.

## Building on this image

To ship your application inside the image rather than mounting it:

```dockerfile
FROM quay.io/bfren/aspnet:net10-7.0

ENV BF_ASPNET_ASSEMBLY=MyApp.dll
COPY ./publish /app/live
```

Add an `overlay/tmp/install` and `RUN bf-install` for anything else your application needs - see [Alpine](https://github.com/bfren/docker-alpine) and [Alpine + S6](https://github.com/bfren/docker-alpine-s6).

## Testing

```sh
./test.nu        # builds the .NET 10 image and runs /test
./test.nu 8      # the same for .NET 8
./test.nu --all  # every version, in parallel
./run.sh         # builds the .NET 10 image and opens a shell in it
```

`/test` runs this image's tests alongside the base images' tests, and fails if tests don't execute:

* **Installation** - `dotnet` runs, the .NET and ASP.NET Core runtimes match the version in the build log, ICU is installed, and the `11-version` start-up script finds the runtime.
* **Switching** - `aspnet-switch` swaps the folders, rolls back when run twice, refuses when nothing is published, and applies the permissions. These use temporary folders, never `/app`.

Run it for each .NET version you change, as each has its own runtime and dependencies. `run.sh` mounts an application folder from the author's machine - change the path to one of yours.

## Troubleshooting

### The logs say the assembly was not found

`BF_ASPNET_ASSEMBLY` must be the file name of your main `.dll` (e.g. `MyApp.dll`, not a path), and the file must be in `/app/live`. Check the volume is mounted to `/app/live` and not `/app`.

### The health check fails, but the application works

The health check loads `/`. If your application returns 404 or 401 there, replace `/etc/bf/health.d/10-aspnet.nu` in your own image (see [Health check](#health-check)).

### My application can't write files

`/app/live` is read-only to the application. Mount another volume for anything it writes, and point your application at it.

### `aspnet-switch` says "Please publish your application first"

`/app/publish` is empty - copy the new version there first.

## FAQs

### Why `live` and `publish` instead of rebuilding the image?

Uploading files and switching is quicker than building and pushing an image for every change, it keeps the previous version ready, and rolling back is one command.

### Why doesn't the container stop when my application crashes?

So that you can start it before the application is published, and so a crash only needs S6 to restart the application. Use `aspnet-switch-terminate` if you want a deployment to restart the whole container.

### Can I use the .NET 11 image?

It is a release candidate - fine for testing, not for production. It will be updated when .NET 11 is released.

## Licence

> [MIT](https://mit.bfren.dev/2021)

## Copyright

> Copyright (c) 2021-2026 [bfren](https://bfren.dev) (unless otherwise stated)
