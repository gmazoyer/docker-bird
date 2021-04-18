FROM debian:buster AS compiler

EXPOSE 179

RUN apt-get update && apt-get install -y \
    autoconf \
	  bison \
	  build-essential \
	  curl \
	  flex \
	  libreadline-dev \
	  libncurses5-dev \
	  m4 \
	  unzip

ARG BIRD_VERSION=2.0.8

RUN curl -O -L https://bird.network.cz/download/bird-${BIRD_VERSION}.tar.gz
RUN tar -zxvf bird-${BIRD_VERSION}.tar.gz

RUN cd bird-${BIRD_VERSION} && \
    autoconf && \
	  autoheader && \
    ./configure --prefix=/usr --sysconfdir=/etc/bird --localstatedir=/var \
    --with-runtimedir=/run/bird && \
    make && \
    make install

FROM debian:buster-slim

RUN apt-get update && \
    apt-get install -y libreadline7 libncurses5 libc6 && \
    rm -rf /var/lib/apt/lists/*

ARG BIRD_VERSION=2.0.8

COPY --from=compiler /bird-${BIRD_VERSION}/bird /bird-${BIRD_VERSION}/birdc /bird-${BIRD_VERSION}/birdcl /usr/local/sbin/

RUN mkdir /etc/bird /run/bird

CMD bird -c /etc/bird/bird.conf -d
