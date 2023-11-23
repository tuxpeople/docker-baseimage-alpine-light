# Runtime stage
FROM docker.io/library/alpine:3.16.5

ENV PACKAGES=\
# renovate: datasource=repology depName=alpine_3_16/iptables versioning=loose
iptables=1.8.8-r1,\
# renovate: datasource=repology depName=alpine_3_16/busybox versioning=loose
busybox=1.35.0-r17,\
# renovate: datasource=repology depName=alpine_3_16/bash versioning=loose
bash=5.1.16-r2,\
# renovate: datasource=repology depName=alpine_3_16/bind-tools versioning=loose
bind-tools=9.16.44-r0,\
# renovate: datasource=repology depName=alpine_3_16/ca-certificates versioning=loose
ca-certificates=20230506-r0,\
# renovate: datasource=repology depName=alpine_3_16/coreutils versioning=loose
coreutils=9.1-r0,\
# renovate: datasource=repology depName=alpine_3_16/curl versioning=loose
curl=8.4.0-r0,\
# renovate: datasource=repology depName=alpine_3_16/jq versioning=loose
jq=1.6-r1,\
# renovate: datasource=repology depName=alpine_3_16/moreutils versioning=loose
moreutils=0.67-r0,\
# renovate: datasource=repology depName=alpine_3_16/nano versioning=loose
nano=6.3-r0,\
# renovate: datasource=repology depName=alpine_3_16/netcat-openbsd versioning=loose
netcat-openbsd=1.130-r3,\
# renovate: datasource=repology depName=alpine_3_16/procps versioning=loose
procps=3.3.17-r2,\
# renovate: datasource=repology depName=alpine_3_16/shadow versioning=loose
shadow=4.10-r3, \
# renovate: datasource=repology depName=alpine_3_16/tini versioning=loose
tini=0.19.0-r0,\
# renovate: datasource=repology depName=alpine_3_16/tzdata versioning=loose
tzdata=2023c-r0,\
# renovate: datasource=repology depName=alpine_3_16/unzip versioning=loose
unzip=6.0-r9,\
# renovate: datasource=repology depName=alpine_3_16/util-linux versioning=loose
util-linux=2.38-r1,\
# renovate: datasource=repology depName=alpine_3_16/wget versioning=loose
wget=1.21.3-r0

# environment variables
ENV PS1="$(whoami)@$(hostname):$(pwd)\\$ " \
    HOME="/root" \
    TERM="xterm"

# hadolint ignore=DL3018,SC2039
RUN \
    echo "**** install runtime packages ****" && \
    apk add --no-cache ${PACKAGES//,/} && \
    echo "**** create abc user and make our folders ****" && \
    groupmod -g 1000 users && \
    useradd -u 911 -U -d /config -s /bin/false abc && \
    usermod -G users abc && \
    sed -i -e 's/^root::/root:!:/' /etc/shadow; mkdir -p \
    /app \
    /config \
    /defaults && \
    echo "**** cleanup ****" && \
    rm -rf \
    /tmp/*

# add local files
COPY root/ /

ENTRYPOINT ["/sbin/tini", "--"]