# apt-cacher-ng-oci

A caching proxy for Debian-based package downloads. Ideal for improving speed and reducing bandwidth in CI pipelines or homelab networks that frequently install packages from Debian, Ubuntu, or other APT-based distributions. Includes built-in log streaming and runtime configuration overrides.

<!-- sf:project:start -->
<!-- sf:project:end -->
<!-- sf:badges:start -->
<!-- sf:badges:end -->
<!-- sf:image:start -->
<!-- sf:image:end -->

### Features

|                          |                                                                    |
| ------------------------ | ------------------------------------------------------------------ |
| **Log Streaming**        | Functional container log streaming via `tail -F` to stdout         |
| **Runtime Overrides**    | Configure PassThroughPattern, concurrency, and timeouts at runtime |
| **Secure Volumes**       | Init-based ownership management for cache and log directories      |
| **Health Checks**        | Built-in HTTP health check against the report page                 |
| **Tini Init**            | Proper signal handling and zombie reaping via tini                  |

### Documentation

| Topic | |
|-------|-|
| [Usage](docs/Usage.md) | Running the image, client configuration, and maintenance |
| [Kubernetes](docs/Kubernetes.md) | Deploying in Kubernetes clusters |

## Installation

```bash
docker run --rm -p 3142:3142 docker.io/prplanit/apt-cacher-ng-oci:latest
```

## License

Apt-Cacher NG is distributed under the [BSD-4-Clause](https://metadata.ftp-master.debian.org/changelogs//main/a/apt-cacher-ng/apt-cacher-ng_3.7.5-1.1_copyright) license.
