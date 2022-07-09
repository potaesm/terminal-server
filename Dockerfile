FROM debian:11

ENV DEBIAN_FRONTEND noninteractive
ENV USER root
RUN echo 'root:$PASSWORD' | chpasswd

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

RUN apt-get update

COPY root.sh /usr/local/bin/root.sh
COPY .bashrc $HOME/.bashrc
ADD https://github.com/tsl0922/ttyd/releases/download/1.6.3/ttyd.x86_64 /usr/local/bin/ttyd

# Clean up
RUN apt-get clean -y && \
    echo "nameserver 8.8.8.8" > /etc/resolv.conf && \
    rm -rf /var/lib/apt/lists/*

# Turn off swap
RUN swapoff -a

RUN chmod +x /usr/local/bin/ttyd

# # Set user and group
# ARG USER=potaesm
# ARG GROUP=appuser
# ARG UID=1000
# ARG GID=1000
# RUN groupadd -g ${GID} ${GROUP}
# RUN useradd -u ${UID} -g ${GROUP} -s /bin/sh -m ${USER}
# # Switch to user
# USER ${UID}:${GID}

# RUN adduser --disabled-password --gecos '' potaesm
# RUN adduser potaesm sudo
# RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

# USER potaesm