FROM ubuntu:bionic

ENV \
  LIBTORRENT_VERSION="1.2.5" \
  _LIBTORRENT_VERSION="1_2_5"

RUN apt-get update

RUN apt-get install -y python3 python3-dev wget build-essential libboost-system-dev libssl-dev libboost-dev libboost-all-dev python3-pip

WORKDIR \
  /opt

#Libtorrent
#If you need static, remove/change --enable-static=no .
#If building locally, you can run make -j$(nproc),
#but you might get issues with swap/out of memory
RUN \
  wget -qO-\
    https://github.com/arvidn/libtorrent/releases/download/libtorrent-${_LIBTORRENT_VERSION}/libtorrent-rasterbar-${LIBTORRENT_VERSION}.tar.gz | \
    tar xvz && \
  cd libtorrent-rasterbar-${LIBTORRENT_VERSION} && \
  ./configure \
    --build=$CBUILD \
    --host=$CHOST \
    --prefix=/usr \
    --enable-python-binding PYTHON=`which python3` \
    --with-boost-python=boost_python3 \
    --enable-static=no \
    --with-boost-system=boost_system \
    --with-libiconv=yes \
    --enable-debug=no \
    --enable-silent-rules && \
  make && \
  make install-strip && \
  strip /usr/lib/python3.6/site-packages/libtorrent.cpython*.so && \
  cd /opt && \
  rm -rf libtorrent-rasterbar-${LIBTORRENT_VERSION} && \
  ldconfig /usr/lib

RUN rm /usr/bin/python

RUN ln -sv /usr/lib/python3.6/site-packages /usr/lib/python3.6/dist-packages
RUN ln /usr/bin/python3 /usr/bin/python
RUN ln /usr/bin/pip3 /usr/bin/pip
