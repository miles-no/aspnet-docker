FROM debian:jessie-backports
MAINTAINER john.stclair@miles.no

ENV RUNTIME_PACKAGES libuv1 libunwind8 gettext libssl-dev libcurl3-dev zlib1g libc-dev

RUN apt-get -qq update \
    && apt-get -qqy install $RUNTIME_PACKAGES \
    && ldconfig \
    && apt-get clean && apt-get autoclean && rm -rf /var/lib/apt/lists/*


COPY ./bin/output /app
WORKDIR /app
EXPOSE 5004
ENTRYPOINT ["/app/kestrel"]

