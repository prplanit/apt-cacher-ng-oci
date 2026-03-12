FROM docker.io/library/debian:trixie-slim

LABEL maintainer="SoFMeRight <sofmeright@gmail.com>" \
    org.opencontainers.image.title="apt-cacher-ng-oci" \
    org.opencontainers.image.description="A caching proxy for Debian-based package downloads — fast APT installs in CI and homelab." \
    org.opencontainers.image.source="https://github.com/prplanit/apt-cacher-ng-oci" \
    org.opencontainers.image.url="https://hub.docker.com/r/prplanit/apt-cacher-ng-oci" \
    org.opencontainers.image.documentation="https://github.com/prplanit/apt-cacher-ng-oci#readme" \
    org.opencontainers.image.licenses="BSD-4-Clause" \
    org.opencontainers.image.vendor="PrecisionPlanIT"

ENV DEBIAN_FRONTEND=noninteractive \
    APT_CACHER_NG_VERSION=3.7.5-1 \
    APT_CACHER_NG_CACHE_DIR=/var/cache/apt-cacher-ng \
    APT_CACHER_NG_LOG_DIR=/var/log/apt-cacher-ng \
    APT_CACHER_NG_USER=apt-cacher-ng \
    PASS_THROUGH_PATTERN='.*' \
    MAX_THREADS=20 \
    NETWORK_TIMEOUT=60

# Install tini and apt-cacher-ng and gosu
RUN apt-get update && apt-get install -y --no-install-recommends \
      apt-cacher-ng="${APT_CACHER_NG_VERSION}" ca-certificates gosu tini wget \
 && rm -rf /var/lib/apt/lists/*

# Override defaults — last value wins, no need to patch acng.conf
RUN printf '%s\n' \
    'ForeGround: 1' \
    'LogDir: /var/log/apt-cacher-ng' \
    'PassThroughPattern: .*' \
    'MaxStandbyConThreads: 20' \
    'MaxConThreads: -1' \
    'NetworkTimeout: 60' \
    'VfileUseRangeOps: 1' \
    'ReuseConnections: 1' \
    'PipelineDepth: 10' \
    > /etc/apt-cacher-ng/zz_overrides.conf

COPY src/entrypoint.sh /sbin/entrypoint.sh
RUN chmod +x /sbin/entrypoint.sh

EXPOSE 3142/tcp

HEALTHCHECK --interval=10s --timeout=2s --retries=3 \
    CMD wget -q -t1 -O /dev/null  http://localhost:3142/acng-report.html || exit 1

ENTRYPOINT ["/usr/bin/tini", "-s", "--", "/sbin/entrypoint.sh"]
CMD []
