ARG BASE_IMAGE=myorg/myapp:latest
FROM $BASE_IMAGE
LABEL maintainer="wonsup@pusnow.com"
LABEL org.opencontainers.image.source https://github.com/Pusnow/dockerfiles

ENV DEBIAN_FRONTEND=noninteractive
RUN printf "\
    deb http://mirror.kakao.com/debian/ buster main \n\
    deb http://security.debian.org/debian-security buster/updates main \n\
    deb http://mirror.kakao.com/debian/ buster-updates main \n"\
    > /etc/apt/sources.list
