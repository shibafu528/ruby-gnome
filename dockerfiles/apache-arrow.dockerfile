FROM ruby:2.7

RUN \
  echo "debconf debconf/frontend select Noninteractive" | \
    debconf-set-selections

RUN \
  apt update && \
  apt install -y -V \
    build-essential \
    ccache \
    clang \
    cmake \
    g++ \
    gcc \
    git \
    libboost-filesystem-dev \
    libboost-regex-dev \
    libboost-system-dev \
    libbrotli-dev \
    libbz2-dev \
    libc-ares-dev \
    libcurl4-openssl-dev \
    libdouble-conversion-dev \
    libgoogle-glog-dev \
    libgrpc++-dev \
    liblz4-dev \
    libprotobuf-dev \
    libprotoc-dev \
    libre2-dev \
    libsnappy-dev \
    libssl-dev \
    libthrift-dev \
    libutf8proc-dev \
    libzstd-dev \
    llvm-dev \
    ninja-build \
    python3-pip \
    pkg-config \
    protobuf-compiler-grpc \
    rapidjson-dev \
    sudo \
    zlib1g-dev

RUN \
  pip3 install --upgrade meson

RUN \
  git clone --depth 1 https://github.com/apache/arrow.git /arrow && \
  mkdir -p /arrow.build && \
  cmake \
    -G Ninja \
    -DARROW_COMPUTE=ON \
    -DARROW_CSV=ON \
    -DARROW_DATASET=ON \
    -DARROW_FILESYSTEM=ON \
    -DARROW_FLIGHT=ON \
    -DARROW_GANDIVA=ON \
    -DARROW_HDFS=ON \
    -DARROW_JSON=ON \
    -DARROW_ORC=ON \
    -DARROW_PARQUET=ON \
    -DARROW_PLASMA=ON \
    -DCMAKE_BUILD_TYPE=Debug \
    -DCMAKE_INSTALL_LIBDIR=lib \
    -DCMAKE_INSTALL_PREFIX=/usr \
    -DProtobuf_SOURCE=BUNDLED \
    -S /arrow/cpp \
    -B /arrow.build/cpp && \
  ninja -C /arrow.build/cpp && \
  ninja -C /arrow.build/cpp install && \
  rm -rf /arrow.build

RUN \
  useradd --user-group --create-home ruby-gnome

RUN \
  echo "ruby-gnome ALL=(ALL:ALL) NOPASSWD:ALL" | \
    EDITOR=tee visudo -f /etc/sudoers.d/ruby-gnome

USER ruby-gnome
WORKDIR /home/ruby-gnome

COPY Gemfile .
RUN bundle install
