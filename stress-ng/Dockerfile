FROM ubuntu:20.04
LABEL maintainer="wonsup@pusnow.com"
LABEL org.opencontainers.image.source https://github.com/Pusnow/dockerfiles


RUN apt-get update \
    && apt-get install --no-install-recommends -y \
    stress-ng \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /var/cache/apt/

ENV STRESS_CPU 1

CMD ["sh", "-c", "stress-ng --cpu ${STRESS_CPU}"]