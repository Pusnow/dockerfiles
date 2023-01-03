ARG DEBIAN_TAG="stable"
FROM debian:${DEBIAN_TAG}-backports
LABEL maintainer="wonsup@pusnow.com"
LABEL org.opencontainers.image.source https://github.com/Pusnow/dockerfiles

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get upgrade -y &&\
    DEBIAN_FRONTEND=noninteractive \
    apt-get install -y \
    sudo \
    tzdata \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /var/cache/apt/



# 2. Change Timezone
ENV TZ="Asia/Seoul"


# 3. Entrypint
ENV UID=0
ENV GID=0

COPY --chown=root:root  debian-entry.sh /__entrypoint.sh
RUN chmod 755 /__entrypoint.sh

VOLUME [ "/conf", "/data" ]
CMD [ "bash" ]
ENTRYPOINT [ "/__entrypoint.sh" ]