# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [8.0.0] - 2026-11-13

### Added

- `BF_ASPNET_ENABLE_DAILY_RESTART` - set it to `1` to restart the application every day at 02:00.

### Changed

- **Breaking:** the daily application restart is now off by default. Set `BF_ASPNET_ENABLE_DAILY_RESTART=1` to keep
  restarting every day, as before.
- .NET 11 updated from release candidate 3 to the released 11.0.0 (standard support, until 2028-11-14).
- .NET 10 updated to 10.0.15.

### Removed

- **Breaking:** .NET 8 and 9 images are no longer built - they reached the end of Microsoft support on 2026-11-10.
  The `net8` and `net9` tags stay at 7.0.2. Move to .NET 10 (long-term support) or 11.

## [7.0.2] - 2026-11-10

### Changed

- Base image updated to `bfren/alpine-s6` 7.0.2, which updates Nushell to 0.117.0 (your own Nushell scripts may
  need changes), keeps the container starting when `BF_TZ` cannot be set, and no longer hides `CURRENT_FILE` and
  `FILE_PWD` from services - see the
  [Alpine + S6 changelog](https://github.com/bfren/docker-alpine-s6/blob/main/CHANGELOG.md).

### Deprecated

- .NET 8 and 9 reached the end of Microsoft support on 2026-11-10. This is the last release with .NET 8 and 9 images -
  later releases build .NET 10 and 11 only. Use .NET 10 for anything new.

## [7.0.1] - 2026-11-06

### Changed

- Base image updated to `bfren/alpine-s6` 7.0.1, which moves to Alpine 3.24.4 (with security fixes) and rebuilds
  BusyBox, figlet and Nushell - see the
  [Alpine + S6 changelog](https://github.com/bfren/docker-alpine-s6/blob/main/CHANGELOG.md).

## [7.0.0] - 2026-11-05

### Changed

- **Breaking:** base image updated to `bfren/alpine-s6` 7.0.0 - see the
  [Alpine + S6 changelog](https://github.com/bfren/docker-alpine-s6/blob/main/CHANGELOG.md).
  `bf env set` must now run as root.
- Images are built and published by the shared `bfren/docker` build workflow (`build.yml`), replacing the separate
  `dev.yml` and `publish.yml` workflows.

[8.0.0]: https://github.com/bfren/docker-aspnet/compare/v7.0.2...v8.0.0
[7.0.2]: https://github.com/bfren/docker-aspnet/compare/v7.0.1...v7.0.2
[7.0.1]: https://github.com/bfren/docker-aspnet/compare/v7.0.0...v7.0.1
[7.0.0]: https://github.com/bfren/docker-aspnet/compare/v6.1.27...v7.0.0
