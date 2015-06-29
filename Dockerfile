FROM debian:jessie
#based on dockerfile by microsoft/aspnet
#based on dockerfile by Jo Shields <jo.shields@xamarin.com>
#based on dockerfile by Michael Friis <friism@gmail.com>

RUN apt-get update \
	&& apt-get install -y curl \
	&& rm -rf /var/lib/apt/lists/*

RUN apt-key adv --keyserver pgp.mit.edu --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF


RUN apt-get -qq update && apt-get -qqy install unzip
# originally added libc6 and libc6-dev (for wheezy) but included in jessie
RUN apt-get -qqy install libunwind8

# Install libuv for Kestrel from source code (binary is not in wheezy and one in jessie is still too old)
RUN apt-get -qqy install \
    autoconf \
    automake \
    build-essential \
    libtool
RUN LIBUV_VERSION=1.4.2 \
    && curl -sSL https://github.com/libuv/libuv/archive/v${LIBUV_VERSION}.tar.gz | tar zxfv - -C /usr/local/src \
    && cd /usr/local/src/libuv-$LIBUV_VERSION \
    && sh autogen.sh && ./configure && make && make install \
    && rm -rf /usr/local/src/libuv-$LIBUV_VERSION \
    && ldconfig


COPY ./bin/output /app
WORKDIR /app
EXPOSE 5004
ENTRYPOINT ["/app/kestrel"]

