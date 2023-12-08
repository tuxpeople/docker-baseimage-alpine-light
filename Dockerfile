# Runtime stage
FROM docker.io/library/alpine:3.19.0

# environment variables
ENV PS1="$(whoami)@$(hostname):$(pwd)\\$ " \
    HOME="/root" \
    TERM="xterm"

SHELL ["/bin/ash", "-o", "pipefail", "-c"]


# hadolint ignore=DL3018
RUN \
    echo "**** install runtime packages ****" && \
    apk add --no-cache --upgrade \
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
        run-parts \ 
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
    /scripts \
    /defaults && \
    echo "**** cleanup ****" && \
    rm -rf \
    /tmp/*

# add local files
COPY root/ /

ENTRYPOINT ["/sbin/tini", "--"]

# ... the names must consist entirely of ASCII upper- and lower-case letters, ASCII digits, ASCII underscores, and ASCII minus-hyphens (note that .sh or . is not allowed), Other files and directories are silently ignored
CMD ["/bin/sh", "-c", "run-parts /scripts; /docker-entrypoint.sh"]