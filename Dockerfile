FROM debian:11

ARG PORT
ARG USERNAME
ARG PASSWORD

ENV PORT ${PORT}
ENV USERNAME ${USERNAME}
ENV PASSWORD ${PASSWORD}

ENV LANG C.UTF-8
ENV LANGUAGE C.UTF-8
ENV LC_ALL C.UTF-8
ENV DEBIAN_FRONTEND noninteractive

# Change root password to "pass"
ENV USER root
RUN echo 'root:pass' | chpasswd

# App utils
RUN apt-get update && \
    apt-get install -y apt-utils 2>&1 | grep -v "debconf: delaying package configuration, since apt-utils is not installed"

# Basic Tools
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    software-properties-common \
    build-essential \
    ca-certificates \
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
    neofetch \
    netcat \
    proxychains \
    certbot

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
# RUN apt-get install -y --no-install-recommends npm && \
#     npm install n --location=global && \
#     n lts
RUN curl https://raw.githubusercontent.com/creationix/nvm/master/install.sh | bash && \
    . /root/.bashrc && \
    nvm install node --lts && \
    nvm install 12 && \
    nvm install 14 && \
    nvm install 16 && \
    nvm install 18 && \
    nvm use stable

# Yarn for node 16 and 18
RUN . /root/.bashrc && \
    nvm use 16 && \
    npm install --location=global yarn && \
    nvm use 18 && \
    npm install --location=global yarn
# Python2
RUN apt-get install -y --no-install-recommends python && \
    curl https://bootstrap.pypa.io/pip/2.7/get-pip.py --output get-pip.py && \
    python2 get-pip.py && \
    rm -rf get-pip.py

# Python3
RUN apt-get install -y --no-install-recommends python3-pip

# Numpy
# RUN pip install numpy virtualenv && pip3 install numpy virtualenv

# Java
RUN apt-get install -y --no-install-recommends default-jre default-jdk

# Ruby
RUN apt-get install -y --no-install-recommends ruby ruby-dev ruby-bundler

# Go
RUN wget https://go.dev/dl/go1.19.5.linux-amd64.tar.gz && \
    tar -C /usr/local -xzf go1.19.5.linux-amd64.tar.gz
RUN echo "export PATH=/usr/local/go/bin:${PATH}" >> /root/.bashrc
RUN rm -rf go1.19.5.linux-amd64.tar.gz

# Config Git
RUN git config --global credential.helper store

# TTYD
COPY root.sh /usr/local/bin/root.sh
COPY .bashrc $HOME/.bashrc
ADD https://github.com/tsl0922/ttyd/releases/download/1.7.3/ttyd.x86_64 /usr/local/bin/ttyd
RUN chmod +x /usr/local/bin/ttyd

# Clean up
RUN apt-get clean -y && \
    # echo "nameserver 1.1.1.1" > /etc/resolv.conf && \
    rm -rf /var/lib/apt/lists/*

# Turn off swap
# RUN swapoff -a

# Add user
RUN adduser --disabled-password --gecos '' potaesm
RUN adduser potaesm sudo
RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

USER potaesm

ENTRYPOINT ttyd -u 0 -g 0 -c ${USERNAME}:${PASSWORD} -p ${PORT} bash

EXPOSE ${PORT}