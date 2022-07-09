FROM debian:bullseye-slim

LABEL maintainer="wonsup@pusnow.com"
LABEL org.opencontainers.image.source https://github.com/Pusnow/dockerfiles

RUN apt-get update && DEBIAN_FRONTEND=noninteractive \
    apt-get install -y \
    sudo \
    tzdata \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /var/cache/apt/



# 2. Change Timezone
ENV TZ="Asia/Seoul"


# 3. Entrypint
ENV UID=2000
ENV GID=2000

COPY --chown=root:root  debian-entry.sh /entrypoint.sh
RUN chmod 755 /entrypoint.sh