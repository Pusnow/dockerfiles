ARG BASE_IMAGE=myorg/myapp:latest
FROM $BASE_IMAGE

ENV DEBIAN_FRONTEND=noninteractive
RUN printf "\
    deb http://mirror.kakao.com/debian/ buster main \n\
    deb http://security.debian.org/debian-security buster/updates main \n\
    deb http://mirror.kakao.com/debian/ buster-updates main \n"\
    > /etc/apt/sources.list
