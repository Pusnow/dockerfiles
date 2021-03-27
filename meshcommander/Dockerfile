FROM node:buster
LABEL maintainer="wonsup@pusnow.com"
LABEL org.opencontainers.image.source https://github.com/Pusnow/dockerfiles

RUN mkdir /app; cd /app; npm install meshcommander

WORKDIR /app/node_modules
CMD ["node", "meshcommander", "--any"]