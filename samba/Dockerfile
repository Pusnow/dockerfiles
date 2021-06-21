FROM alpine:latest
LABEL maintainer="wonsup@pusnow.com"
LABEL org.opencontainers.image.source https://github.com/Pusnow/dockerfiles

RUN apk add --no-cache \
    samba \
    shadow

EXPOSE 445
ENV USER1=user1
ENV UID1=1000
ENV USER2=user2
ENV UID2=1001

COPY run.sh /run.sh

VOLUME ["/config", "/db"]
CMD ["/run.sh"]
