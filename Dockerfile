FROM alpine AS compiler

RUN apk --update add autoconf bison curl flex gcc g++ linux-headers m4 make ncurses-dev readline-dev unzip zlib-dev

ARG BIRD_VERSION=2.0.9

RUN curl -O -L https://bird.network.cz/download/bird-${BIRD_VERSION}.tar.gz
RUN tar -zxvf bird-${BIRD_VERSION}.tar.gz

RUN cd bird-${BIRD_VERSION} && \
    autoconf && \
    autoheader && \
    ./configure --prefix=/usr --sysconfdir=/etc/bird --localstatedir=/var \
    --with-runtimedir=/run/bird && \
    make && \
    make install

FROM alpine

ARG BIRD_VERSION=2.0.9

COPY --from=compiler /bird-${BIRD_VERSION}/bird /bird-${BIRD_VERSION}/birdc /bird-${BIRD_VERSION}/birdcl /usr/local/sbin/

RUN mkdir /etc/bird /run/bird

EXPOSE 179

CMD bird -c /etc/bird/bird.conf -d
