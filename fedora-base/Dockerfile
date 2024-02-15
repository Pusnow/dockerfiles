ARG PS_FEDORA_TAG
FROM fedora:${PS_FEDORA_TAG}
LABEL maintainer="wonsup@pusnow.com"
LABEL org.opencontainers.image.source https://github.com/Pusnow/dockerfiles

RUN dnf -y update && dnf -y install \
    sudo \
    tzdata \
    && dnf clean all



# 2. Change Timezone
ENV TZ="Asia/Seoul"


# 3. Entrypint
ENV UID=0
ENV GID=0
ENV SUDO="Y"

COPY --chown=root:root  fedora-entry.sh /__entrypoint.sh
RUN chmod 755 /__entrypoint.sh

VOLUME [ "/conf", "/data" ]
CMD [ "bash" ]
ENTRYPOINT [ "/__entrypoint.sh" ]