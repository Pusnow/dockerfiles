FROM node:alpine
LABEL maintainer="wonsup@pusnow.com"
LABEL org.opencontainers.image.source https://github.com/Pusnow/dockerfiles

RUN apk add --no-cache \
    openssh

RUN mkdir /app; cd /app; npm install meshcommander

WORKDIR /app/node_modules

VOLUME [ "/root", "/keys" ]
COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT [ "/entrypoint.sh" ]
