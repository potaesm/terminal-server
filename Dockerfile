FROM debian:11

ENV DEBIAN_FRONTEND noninteractive
ENV USER root
RUN echo 'root:$PASSWORD' | chpasswd

# App utils
RUN apt-get update && \
    apt-get install -y apt-utils 2>&1 | grep -v "debconf: delaying package configuration, since apt-utils is not installed"

# Basic Tools
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    software-properties-common \
    build-essential \
    ca-certificates \
    locales \
    gnupg2 \
    libjson-c-dev \
    libwebsockets-dev \
    unzip \
    bzip2 \
    wget \
    curl \
    telnet \
    openvpn \
    openssh-server \
    openssh-client \
    nano \
    vim \
    net-tools \
    dumb-init \
    htop \
    man \
    procps \
    cmake \
    git \
    rsync \
    sudo \
    fakeroot \
    fakechroot \
    nmap \
    neofetch

# Set Locale and Timezone
RUN echo "LC_ALL=en_US.UTF-8" >> /etc/environment && \
    echo "LANG=en_US.UTF-8" > /etc/locale.conf && \
    echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen && \
    dpkg-reconfigure -f noninteractive locales

# Set Timezone
RUN rm /etc/localtime && \
    echo "Asia/Bangkok" > /etc/timezone && \
    dpkg-reconfigure -f noninteractive tzdata

# Thai fonts
RUN apt-get install -y --no-install-recommends xfonts-thai

# Add Kali source
# RUN echo "deb http://http.kali.org/kali kali-rolling main contrib non-free" >> /etc/apt/sources.list
# RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys ED444FF07D8D0BF6

RUN apt-get update

# NodeJS
RUN apt-get install -y --no-install-recommends npm && \
    npm install n -g && \
    n lts

# Python2
RUN apt-get install -y --no-install-recommends python && \
    curl https://bootstrap.pypa.io/pip/2.7/get-pip.py --output get-pip.py && \
    python2 get-pip.py && \
    rm -rf get-pip.py

# Python3
RUN apt-get install -y --no-install-recommends python3-pip

# Numpy
RUN pip install numpy && pip3 install numpy

# Java
RUN apt-get install -y --no-install-recommends default-jre default-jdk

# Ruby
RUN apt-get install -y --no-install-recommends ruby ruby-dev ruby-bundler

# Config Git
RUN git config --global credential.helper store

COPY root.sh /usr/local/bin/root.sh
COPY .bashrc $HOME/.bashrc
ADD https://github.com/tsl0922/ttyd/releases/download/1.6.3/ttyd.x86_64 /usr/local/bin/ttyd

# Clean up
RUN apt-get clean -y && \
    echo "nameserver 8.8.8.8" > /etc/resolv.conf && \
    rm -rf /var/lib/apt/lists/*

# Turn off swap
RUN swapoff -a

# Make ttyd executable
RUN chmod +x /usr/local/bin/ttyd

# Add user
# RUN adduser --disabled-password --gecos '' potaesm
# RUN adduser potaesm sudo
# RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

# USER potaesm