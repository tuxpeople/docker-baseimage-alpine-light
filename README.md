# baseimage-alpine
![Github Workflow Badge](https://github.com/tuxpeople/docker-baseimage-alpine/actions/workflows/release.yml/badge.svg)
![Github Last Commit Badge](https://img.shields.io/github/last-commit/tuxpeople/docker-baseimage-alpine)
![Docker Pull Badge](https://img.shields.io/docker/pulls/tdeutsch/baseimage-alpine)
![Docker Stars Badge](https://img.shields.io/docker/stars/tdeutsch/baseimage-alpine)
![Docker Size Badge](https://img.shields.io/docker/image-size/tdeutsch/baseimage-alpine)

## Quick reference

I made this container to debug container infrastructure (eg. Kubernetes). 
This is a image with many handy tools in it.

* **Code repository:**
  https://github.com/tuxpeople/docker-baseimage-alpine
* **Where to file issues:**
  https://github.com/tuxpeople/docker-baseimage-alpine/issues
* **Supported architectures:**
  ```amd64```, ```armv7``` and ```arm64```

## Image tags
- ```latest``` gets automatically built on every push to master and also via a weekly cron job

## Usage

```sh
docker pull tdeutsch/baseimage-alpine:<tag>
```

or

```sh
docker pull quay.io/tdeutsch/baseimage-alpine:<tag>
```

