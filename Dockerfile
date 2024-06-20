# Runtime stage
FROM docker.io/library/alpine:3.20.1

# environment variables
ENV PS1="$(whoami)@$(hostname):$(pwd)\\$ " \
    HOME="/root" \
    TERM="xterm"

SHELL ["/bin/ash", "-o", "pipefail", "-c"]


# hadolint ignore=DL3018
RUN \
    echo "**** install runtime packages ****" && \
    apk add --no-cache --upgrade \
     #   bash \ 
    #    bind-tools \ 
        busybox \ 
        ca-certificates \ 
     #   coreutils \ 
        curl \ 
     #   iptables \ 
     #   jq \ 
     #   moreutils \ 
     #   nano \ 
     #   netcat-openbsd \ 
        run-parts \ 
     #   shadow \ 
        tini \ 
        tzdata \ 
     #   unzip \ 
     #   util-linux \ 
        wget \ 
    || exit 1 && \
    echo "**** create abc user and make our folders ****" && \
    addgroup -S abc && \
    adduser -S -h /config -D -s /bin/false abc -G abc && \
    mkdir -p /app && chown -R abc:abc /app && chmod -R 775 /app && chmod g+s /app && \
    mkdir -p /config && chown -R abc:abc /config && chmod -R 775 /config && chmod g+s /config && \
    mkdir -p /scripts && chown -R abc:abc /scripts && chmod -R 775 /scripts && chmod g+s /scripts && \
    mkdir -p /defaults && chown -R abc:abc /defaults && chmod -R 775 /defaults && chmod g+s /defaults && \
    echo "**** cleanup ****" && \
    rm -rf \
    /tmp/*

# add local files
COPY --chown=abc:abc --chmod=774 root/ /

ENTRYPOINT ["/sbin/tini", "--"]

# ... the names must consist entirely of ASCII upper- and lower-case letters, ASCII digits, ASCII underscores, and ASCII minus-hyphens (note that .sh or . is not allowed), Other files and directories are silently ignored
CMD ["/bin/sh", "-c", "run-parts /scripts; /app/docker-entrypoint.sh"]