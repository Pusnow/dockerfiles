ARG PS_DEBIAN_TAG
FROM debian:${PS_DEBIAN_TAG}
LABEL maintainer="wonsup@pusnow.com"
LABEL org.opencontainers.image.source https://github.com/Pusnow/dockerfiles
ENV DEBIAN_FRONTEND=noninteractive
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
ENV SUDO="Y"

COPY --chown=root:root  debian-entry.sh /__entrypoint.sh
RUN chmod 755 /__entrypoint.sh

VOLUME [ "/conf", "/data" ]
CMD [ "bash" ]
ENTRYPOINT [ "/__entrypoint.sh" ]