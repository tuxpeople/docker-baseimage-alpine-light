# Runtime stage
FROM docker.io/library/alpine:3.17

# environment variables
ENV PS1="$(whoami)@$(hostname):$(pwd)\\$ " \
    HOME="/root" \
    TERM="xterm"

SHELL ["/bin/ash", "-o", "pipefail", "-c"]


# hadolint ignore=DL3018
RUN \
    echo "**** install runtime packages ****" && \
    apk add --no-cache \
        bash \ 
        bind-tools \ 
        busybox \ 
        ca-certificates \ 
        coreutils \ 
        curl \ 
        iptables \ 
        jq \ 
        moreutils \ 
        nano \ 
        netcat-openbsd \ 
        shadow \ 
        tini \ 
        tzdata \ 
        unzip \ 
        util-linux \ 
        wget \ 
    || exit 1 && \
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