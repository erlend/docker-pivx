FROM alpine:3.6

ENV PIVX_VERSION=2.3.1 DB_VERSION=4.8.30.NC

RUN deps="alpine-sdk curl autoconf automake libtool boost-dev openssl-dev" && \
    apk add -U $deps dumb-init boost boost-program_options libssl1.0 && \
    curl -L http://download.oracle.com/berkeley-db/db-$DB_VERSION.tar.gz \
    | tar zx && \
    cd /db-$DB_VERSION/build_unix && \
    ../dist/configure \
      --prefix=/opt/db \
      --enable-cxx \
      --disable-shared \
      --with-pic && \
    make install && \
    curl -L https://github.com/PIVX-Project/PIVX/archive/v$PIVX_VERSION.tar.gz \
    | tar zxC / && \
    cd /PIVX-$PIVX_VERSION && \
    ./autogen.sh && \
    ./configure LDFLAGS=-L/opt/db/lib CPPFLAGS=-I/opt/db/include \
      && \
    make install && \
    adduser -D pivx && \
    apk del $deps && \
    rm -r /opt/db/docs /var/cache/apk/* /PIVX-$PIVX_VERSION /db-$DB_VERSION

COPY entrypoint.sh /
ENTRYPOINT ["/entrypoint.sh"]
USER pivx
