FROM ubuntu:18.04

# set version label
# Build-time metadata as defined at http://label-schema.org
ARG BUILD_DATE
ARG VCS_REF
ARG VERSION
LABEL org.label-schema.build-date=$BUILD_DATE \
      org.label-schema.vcs-ref=$VCS_REF \
      org.label-schema.vcs-url="https://github.com/computerfr33k/video_transcoding_docker" \
      org.label-schema.version=$VERSION \
      org.label-schema.schema-version="1.0"
LABEL maintainer="computerfr33k"

# global environment settings
# https://github.com/donmelton/video_transcoding/releases
ENV GEM_VERSION=0.25.2 \
# https://handbrake.fr/downloads.php
HANDBRAKE_VERSION=1.2.2 \
# https://ffmpeg.org/download.html#releases
FFMPEG_VERSION=4.1.3 \
# https://bitbucket.org/multicoreware/x265/wiki/Home
LIBX265_VERSION=3.0

# install build dependencies to compile ffmpeg from master
RUN set -ex \
  && buildDeps=' \
    autoconf \
    automake \
    build-essential \
    cmake \
    cmake-curses-gui \
    curl \
    git \
    libass-dev \
    libbz2-dev \
    libfontconfig1-dev \
    libfreetype6-dev \
    libfribidi-dev \
    libharfbuzz-dev \
    libjansson-dev \
    liblzma-dev \
    libmp3lame-dev \
    libogg-dev \
    libopus-dev \
    libsamplerate-dev \
    libspeex-dev \
    libtheora-dev \
    libtool \
    libtool-bin \
    libvorbis-dev \
    libvpx-dev \
    libx264-dev \
    libxml2-dev \
    m4 \
    make \
    mercurial \
    mkvtoolnix \
    mp4v2-utils \
    mpv \
    nasm \
    patch \
    pkg-config \
    python \
    ruby-full \
    tar \
    texinfo \
    unzip \
    wget \
    yasm \
    zlib1g-dev \
  ' \
  && apt-get update \
  && apt-get install -y --no-install-recommends $buildDeps \
  && mkdir -p /usr/src/ffmpeg/bin \
  && mkdir -p /usr/src/ffmpeg/build \
  && PATH="/usr/src/ffmpeg/bin:$PATH" \
  && cd /usr/src/ffmpeg \
  # libx265
  && wget -O x265.tar.gz https://bitbucket.org/multicoreware/x265/downloads/x265_$LIBX265_VERSION.tar.gz \
  && tar xzvf x265.tar.gz \
  && cd x265_$LIBX265_VERSION/build/linux \
  && PATH="/usr/src/ffmpeg/bin:$PATH" cmake -G "Unix Makefiles" -DCMAKE_INSTALL_PREFIX="/usr/src/ffmpeg/build" -DENABLE_SHARED:bool=off ../../source \
  && PATH="/usr/src/ffmpeg/bin:$PATH" make -j"$(nproc)" \
  && make install \
  && cd /usr/src/ffmpeg \
  && rm -rf x265 \
  # HandbrakeCli Release
  && wget https://download2.handbrake.fr/$HANDBRAKE_VERSION/HandBrake-$HANDBRAKE_VERSION-source.tar.bz2 \
  && tar xvjf HandBrake-$HANDBRAKE_VERSION-source.tar.bz2 \
  && cd HandBrake-$HANDBRAKE_VERSION \
  && ./configure --launch-jobs=$(nproc) --disable-gtk --launch \
  && cd build && make install \
  && cd /usr/src/ffmpeg \
  && rm -rf HandBrake-$HANDBRAKE_VERSION HandBrake-$HANDBRAKE_VERSION-source.tar.bz2 \
  # FFmpeg
  && wget -O ffmpeg.tar.gz https://github.com/FFmpeg/FFmpeg/archive/n$FFMPEG_VERSION.tar.gz \
  && tar zxvf ffmpeg.tar.gz \
  && mv FFmpeg* ffmpeg_src \
  && cd ffmpeg_src \
  && PATH="/usr/src/ffmpeg/bin:$PATH" PKG_CONFIG_PATH="/usr/src/ffmpeg/build/lib/pkgconfig" ./configure \
    --prefix="/usr/src/ffmpeg/build" \
    --pkg-config-flags="--static" \
    --extra-cflags="-I/usr/src/ffmpeg/build/include" \
    --extra-ldflags="-L/usr/src/ffmpeg/build/lib" \
    --bindir="/usr/src/ffmpeg/bin" \
    --extra-libs=-lpthread \
    --enable-gpl \
    --enable-libass \
    --enable-libfreetype \
    --enable-libmp3lame \
    --enable-libopus \
    --enable-libtheora \
    --enable-libvorbis \
    --enable-libvpx \
    --enable-libx264 \
    --enable-libx265 \
    --enable-nonfree \
  && PATH="/usr/src/ffmpeg/bin:$PATH" make -j"$(nproc)" \
  && make install \
  && hash -r \
  && cd / \
  && mv /usr/src/ffmpeg/bin/ff* /usr/local/bin \
  && rm -rf /usr/src/ffmpeg \
  && apt-get clean \
  && rm -rf \
    /tmp/* \
    /var/lib/apt/lists/* \
    /var/tmp/*

RUN set -ex \
  # Install application dependencies
  && apt-get purge -y --auto-remove $buildDeps \
  && rm -rf /var/lib/apt/lists/* \
  && gem install video_transcoding -v "$GEM_VERSION" \
  && mkdir /data

WORKDIR /data

CMD [ "/bin/bash" ]
