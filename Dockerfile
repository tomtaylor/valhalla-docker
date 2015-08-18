FROM phusion/baseimage:0.9.17

CMD ["/sbin/my_init"]
EXPOSE 8002

RUN apt-get update && apt-get install -y \
  autoconf \
  automake \
  libtool \
  make \
  gcc-4.8 \
  g++-4.8 \
  libboost1.54-dev \
  libboost-program-options1.54-dev \
  libboost-filesystem1.54-dev \
  libboost-system1.54-dev \
  libboost-thread1.54-dev \
  protobuf-compiler \
  libprotobuf-dev \
  lua5.2 \
  liblua5.2-dev \
  git \
  libsqlite3-dev \
  libspatialite-dev \
  libgeos-dev \
  libgeos++-dev \
  libcurl4-openssl-dev \
  wget

RUN update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-4.8 90 && \
  update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-4.8 90

RUN mkdir /valhalla
WORKDIR /valhalla

RUN git clone --depth=1 --recurse-submodules --single-branch --branch=master https://github.com/zeromq/libzmq.git
RUN cd libzmq && \
  ./autogen.sh && \
  ./configure --without-libsodium --without-documentation && \
  make -j4 && \
  make install && \
  cd ..

RUN git clone --depth=1 --recurse-submodules --single-branch --branch=master https://github.com/kevinkreiser/prime_server.git
RUN cd prime_server && \
  ./autogen.sh && \
  ./configure && \
  make -j4 && \
  make install && \
  cd ..

ADD midgard midgard
RUN cd midgard && ./autogen.sh && ./configure CPPFLAGS=-DBOOST_SPIRIT_THREADSAFE && make -j4 && make install && cd ..

ADD baldr baldr
RUN cd baldr && ./autogen.sh && ./configure CPPFLAGS=-DBOOST_SPIRIT_THREADSAFE && make -j4 && make install && cd ..

ADD sif sif
RUN cd sif && ./autogen.sh && ./configure CPPFLAGS=-DBOOST_SPIRIT_THREADSAFE && make -j4 && make install && cd ..

ADD mjolnir mjolnir
RUN cd mjolnir && ./autogen.sh && ./configure CPPFLAGS=-DBOOST_SPIRIT_THREADSAFE && make -j4 && make install && cd ..

ADD loki loki
RUN cd loki && ./autogen.sh && ./configure CPPFLAGS=-DBOOST_SPIRIT_THREADSAFE && make -j4 && make install && cd ..

ADD odin odin
RUN cd odin && ./autogen.sh && ./configure CPPFLAGS=-DBOOST_SPIRIT_THREADSAFE && make -j4 && make install && cd ..

ADD thor thor
RUN cd thor && ./autogen.sh && ./configure CPPFLAGS=-DBOOST_SPIRIT_THREADSAFE && make -j4 && make install && cd ..

ADD tyr tyr
RUN cd tyr && ./autogen.sh && ./configure CPPFLAGS=-DBOOST_SPIRIT_THREADSAFE && make -j4 && make install && cd ..

RUN ldconfig

RUN mkdir /data
# Change this OSM extract to somewhere else if you like.
RUN wget http://download.geofabrik.de/europe/great-britain/england/greater-london-latest.osm.pbf
RUN cd mjolnir && pbfgraphbuilder -c conf/valhalla.json ../greater-london-latest.osm.pbf && cd ..

RUN mkdir /etc/service/tyr
ADD tyr.sh /etc/service/tyr/run

RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
