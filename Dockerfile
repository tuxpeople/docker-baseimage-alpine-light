FROM alpine:3.14.2 as rootfs-stage
ARG TARGETPLATFORM

# environment
ENV MIRROR=http://dl-cdn.alpinelinux.org/alpine
ENV PACKAGES=alpine-baselayout,\
alpine-keys,\
apk-tools,\
busybox,\
libc-utils,\
xz

# install packages
# hadolint ignore=DL3018
RUN \
 apk add --no-cache \
	bash \
	curl \
	tzdata \
	xz

# fetch builder script from gliderlabs
# hadolint ignore=SC2046,SC2034,SC2002,DL4006,SC2155
RUN \
 case ${TARGETPLATFORM} in \
  "linux/amd64")  export ARCH=x86_64  ;; \
  "linux/arm64")  export ARCH=aarch64  ;; \
  "linux/arm/v7") export ARCH=armv7  ;; \
 esac; \
 export REL="v$(cat /etc/alpine-release | cut -d'.' -f1-2)" && \
 curl -o \
 /mkimage-alpine.bash -L \
	https://raw.githubusercontent.com/gliderlabs/docker-alpine/master/builder/scripts/mkimage-alpine.bash && \
 chmod +x \
	/mkimage-alpine.bash && \
 ./mkimage-alpine.bash && \
 mkdir /root-out && \
 tar xf \
	/rootfs.tar.xz -C \
	/root-out && \
 sed -i -e 's/^root::/root:!:/' /root-out/etc/shadow

# Runtime stage
FROM scratch
COPY --from=rootfs-stage /root-out/ /
ARG TARGETPLATFORM

# environment variables
ENV PS1="$(whoami)@$(hostname):$(pwd)\\$ " \
HOME="/root" \
TERM="xterm"

# hadolint ignore=DL3018
RUN \
 echo "**** install build packages ****" && \
 apk add --no-cache --virtual=build-dependencies \
	curl \
	tar && \
 echo "**** install runtime packages ****" && \
 apk add --no-cache \
	bash \
	ca-certificates \
	coreutils \
	procps \
	shadow \
	tzdata && \
 echo "**** add s6 overlay ****" && \
 case ${TARGETPLATFORM} in \
  "linux/amd64")  OVERLAY_ARCH=amd64  ;; \
  "linux/arm64")  OVERLAY_ARCH=aarch64  ;; \
  "linux/arm/v7") OVERLAY_ARCH=armhf  ;; \
 esac; \
 curl -o \
 /tmp/s6-overlay-installer -L \
	"https://github.com/just-containers/s6-overlay/releases/latest/download/s6-overlay-${OVERLAY_ARCH}-installer" && \
 chmod +x /tmp/s6-overlay-installer && /tmp/s6-overlay-installer / && rm /tmp/s6-overlay-installer && \
 echo "**** create abc user and make our folders ****" && \
 groupmod -g 1000 users && \
 useradd -u 911 -U -d /config -s /bin/false abc && \
 usermod -G users abc && \
 mkdir -p \
	/app \
	/config \
	/defaults && \
 mv /usr/bin/with-contenv /usr/bin/with-contenvb && \
 echo "**** cleanup ****" && \
 apk del --purge \
	build-dependencies && \
 rm -rf \
	/tmp/*

# add local files
COPY root/ /

ENTRYPOINT ["/init"]
