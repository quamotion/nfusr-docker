FROM ubuntu:xenial

RUN apt-get update \
&& apt-get upgrade -y

RUN apt-get install -y git autoconf build-essential libtool pkg-config libfuse-dev \
# Delete all the apt list files since they're big and get stale quickly
&& rm -rf /var/lib/apt/lists/*

RUN git clone https://github.com/facebookincubator/nfusr ~/nfusr \
&& git clone https://github.com/sahlberg/libnfs ~/libnfs

RUN cd ~/libnfs \
&& ./bootstrap \
&& ./configure \
&& make \
&& DESTDIR=/out make install \
&& make install

RUN cd ~/nfusr \
&& ./bootstrap \
&& ./configure \
&& make \
&& DESTDIR=/out make install

FROM ubuntu:xenial

WORKDIR /

RUN apt-get update \
&& apt-get install -y libfuse2 \
# Delete all the apt list files since they're big and get stale quickly
&& rm -rf /var/lib/apt/lists/*

COPY --from=0 /out/usr/ /usr/
COPY --from=0 /out/sbin/ /sbin/
