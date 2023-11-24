# Runtime stage
FROM docker.io/library/alpine:3.17

# renovate: datasource=repology depName=alpine_3_18/iptables versioning=loose
ENV iptables_pkgversion="1.8.8-r1"
# renovate: datasource=repology depName=alpine_3_18/busybox versioning=loose
ENV busybox_pkgversion="1.35.0-r17"
# renovate: datasource=repology depName=alpine_3_18/bash versioning=loose
ENV bash_pkgversion="5.1.16-r2"
# renovate: datasource=repology depName=alpine_3_18/bind-tools versioning=loose
ENV bind-tools_pkgversion="9.16.44-r0"
# renovate: datasource=repology depName=alpine_3_18/ca-certificates versioning=loose
ENV ca-certificates_pkgversion="20230506-r0"
# renovate: datasource=repology depName=alpine_3_18/coreutils versioning=loose
ENV coreutils_pkgversion="9.1-r0"
# renovate: datasource=repology depName=alpine_3_18/curl versioning=loose
ENV curl_pkgversion="8.4.0-r0"
# renovate: datasource=repology depName=alpine_3_18/jq versioning=loose
ENV jq_pkgversion="1.6-r1"
# renovate: datasource=repology depName=alpine_3_18/moreutils versioning=loose
ENV moreutils_pkgversion="0.67-r0"
# renovate: datasource=repology depName=alpine_3_18/nano versioning=loose
ENV nano_pkgversion="6.3-r0"
# renovate: datasource=repology depName=alpine_3_18/netcat-openbsd versioning=loose
ENV netcat-openbsd_pkgversion="1.130-r3"
# renovate: datasource=repology depName=alpine_3_18/procps-ng versioning=loose
ENV procps-ng_pkgversion="3.3.17-r2"
# renovate: datasource=repology depName=alpine_3_18/shadow versioning=loose
ENV shadow_pkgversion="4.10-r3"
# renovate: datasource=repology depName=alpine_3_18/tini versioning=loose
ENV tini_pkgversion="0.19.0-r0"
# renovate: datasource=repology depName=alpine_3_18/tzdata versioning=loose
ENV tzdata_pkgversion="2023c-r0"
# renovate: datasource=repology depName=alpine_3_18/unzip versioning=loose
ENV unzip_pkgversion="6.0-r9"
# renovate: datasource=repology depName=alpine_3_18/util-linux versioning=loose
ENV util-linux_pkgversion="2.38-r1"
# renovate: datasource=repology depName=alpine_3_18/wget versioning=loose
ENV wget_pkgversion="1.21.3-r0"

# environment variables
ENV PS1="$(whoami)@$(hostname):$(pwd)\\$ " \
    HOME="/root" \
    TERM="xterm"

SHELL ["/bin/ash", "-o", "pipefail", "-c"]


# hadolint ignore=DL3018
RUN \
    echo "**** install runtime packages ****" && \
    PACKAGES=""; for PKG in "$(env | grep _pkgversion | sed 's/_pkgversion//g')"; do PACKAGES="${PACKAGES} ${PKG}" ; done && \
    apk add --no-cache ${PACKAGES} || exit 1 && \
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