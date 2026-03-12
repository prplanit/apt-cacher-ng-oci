FROM docker.io/library/ubuntu:24.04

LABEL maintainer="SoFMeRight <sofmeright@gmail.com>" \
    org.opencontainers.image.title="apt-cacher-ng-oci" \
    org.opencontainers.image.description="A caching proxy for Debian-based package downloads — fast APT installs in CI and homelab." \
    org.opencontainers.image.source="https://github.com/prplanit/apt-cacher-ng-oci" \
    org.opencontainers.image.url="https://hub.docker.com/r/prplanit/apt-cacher-ng-oci" \
    org.opencontainers.image.documentation="https://github.com/prplanit/apt-cacher-ng-oci#readme" \
    org.opencontainers.image.licenses="BSD-4-Clause" \
    org.opencontainers.image.vendor="PrecisionPlanIT"

ENV DEBIAN_FRONTEND=noninteractive \
    APT_CACHER_NG_CACHE_DIR=/var/cache/apt-cacher-ng \
    APT_CACHER_NG_LOG_DIR=/var/log/apt-cacher-ng \
    APT_CACHER_NG_USER=apt-cacher-ng \
    PASS_THROUGH_PATTERN='.*' \
    MAX_THREADS=20 \
    NETWORK_TIMEOUT=60

# Install tini and apt-cacher-ng and gosu
RUN apt-get update && apt-get install -y --no-install-recommends \
      apt-cacher-ng ca-certificates gosu tini wget \
 && rm -rf /var/lib/apt/lists/*

# Patch config: set ForeGround mode, passthrough pattern, and valid concurrency settings
RUN sed -i 's|# ForeGround: .*|ForeGround: 1|' /etc/apt-cacher-ng/acng.conf && \
    sed -i 's|# LogDir: .*|LogDir: /var/log/apt-cacher-ng|' /etc/apt-cacher-ng/acng.conf && \
    # Handle PassThroughPattern
    (grep -q '^PassThroughPattern:' /etc/apt-cacher-ng/acng.conf && \
      sed -i "s|^PassThroughPattern:.*|PassThroughPattern: ${PASS_THROUGH_PATTERN}|" /etc/apt-cacher-ng/acng.conf || \
      echo "PassThroughPattern: ${PASS_THROUGH_PATTERN}" >> /etc/apt-cacher-ng/acng.conf) && \
    # Add concurrency optimizations based on the config file
    sed -i 's|# MaxStandbyConThreads: .*|MaxStandbyConThreads: 20|' /etc/apt-cacher-ng/acng.conf && \
    sed -i 's|# MaxConThreads: .*|MaxConThreads: -1|' /etc/apt-cacher-ng/acng.conf && \
    sed -i 's|# NetworkTimeout: .*|NetworkTimeout: 60|' /etc/apt-cacher-ng/acng.conf && \
    sed -i 's|# VfileUseRangeOps: .*|VfileUseRangeOps: 1|' /etc/apt-cacher-ng/acng.conf && \
    sed -i 's|# ReuseConnections: .*|ReuseConnections: 1|' /etc/apt-cacher-ng/acng.conf && \
    sed -i 's|# PipelineDepth: .*|PipelineDepth: 10|' /etc/apt-cacher-ng/acng.conf && \
    # Add settings if they don't exist
    grep -q '^MaxStandbyConThreads:' /etc/apt-cacher-ng/acng.conf || echo "MaxStandbyConThreads: 20" >> /etc/apt-cacher-ng/acng.conf && \
    grep -q '^MaxConThreads:' /etc/apt-cacher-ng/acng.conf || echo "MaxConThreads: -1" >> /etc/apt-cacher-ng/acng.conf && \
    grep -q '^VfileUseRangeOps:' /etc/apt-cacher-ng/acng.conf || echo "VfileUseRangeOps: 1" >> /etc/apt-cacher-ng/acng.conf && \
    grep -q '^NetworkTimeout:' /etc/apt-cacher-ng/acng.conf || echo "NetworkTimeout: 60" >> /etc/apt-cacher-ng/acng.conf && \
    grep -q '^ReuseConnections:' /etc/apt-cacher-ng/acng.conf || echo "ReuseConnections: 1" >> /etc/apt-cacher-ng/acng.conf && \
    grep -q '^PipelineDepth:' /etc/apt-cacher-ng/acng.conf || echo "PipelineDepth: 10" >> /etc/apt-cacher-ng/acng.conf

COPY entrypoint.sh /sbin/entrypoint.sh
RUN chmod +x /sbin/entrypoint.sh

EXPOSE 3142/tcp

HEALTHCHECK --interval=10s --timeout=2s --retries=3 \
    CMD wget -q -t1 -O /dev/null  http://localhost:3142/acng-report.html || exit 1

ENTRYPOINT ["/usr/bin/tini", "-s", "--", "/sbin/entrypoint.sh"]
CMD []