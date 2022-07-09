FROM debian:11

ENV DEBIAN_FRONTEND noninteractive

# Basic Tools
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    software-properties-common \
    build-essential \
    ca-certificates \
    gnupg2 \
    apt-utils \
    libjson-c-dev \
    libwebsockets-dev \
    unzip \
    bzip2 \
    wget \
    curl \
    openssh-server \
    openssh-client \
    nano \
    vim \
    dumb-init \
    htop \
    locales \
    man \
    procps \
    cmake \
    git \
    rsync \
    sudo \
    fakechroot \
    neofetch

COPY root.sh /usr/local/bin/root.sh
COPY .bashrc $HOME/.bashrc
ADD https://github.com/tsl0922/ttyd/releases/download/1.6.3/ttyd_linux.x86_64 /usr/local/bin/ttyd

RUN chmod +x /usr/local/bin/ttyd