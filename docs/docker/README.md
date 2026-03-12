# Docker Deployment

## Quick Start

```bash
docker run --name apt-cacher-ng --init -d --restart=always \
  -p 3142:3142 \
  -v /srv/apt-cacher-ng/cache:/var/cache/apt-cacher-ng \
  -v /srv/apt-cacher-ng/log:/var/log/apt-cacher-ng \
  docker.io/prplanit/apt-cacher-ng-oci:latest
```

## Docker Compose

Copy or reference the [docker-compose.yaml](docker-compose.yaml) in this directory:

```bash
docker compose up -d
```

## Building from Source

```bash
git clone https://gitlab.prplanit.com/precisionplanit/apt-cacher-ng-oci && cd apt-cacher-ng-oci
docker build -t prplanit/apt-cacher-ng-oci .
```
