FROM ubuntu:20.04

ENV DEBIAN_FRONTEND noninteractive
ARG NODE_MAJOR_VERSION=14
ARG NPM_GLOBAL_MODULES

RUN apt-get update \
    && apt-get install -qq \
        apt-transport-https \
        build-essential \
        ca-certificates \
        curl \
        git \
        gnupg-agent \
        lsb-release \
        openssh-server \
        software-properties-common \
        wget \
        xz-utils \
        --no-install-recommends \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && ln -s python3 /usr/bin/python


# Install npm nodejs and yarn

RUN curl -sSL https://deb.nodesource.com/gpgkey/nodesource.gpg.key \
        | apt-key add - \
    && version=node_${NODE_MAJOR_VERSION}.x \
    && distro="$(lsb_release -cs)" \
    && echo "deb https://deb.nodesource.com/$version $distro main" \
        | tee /etc/apt/sources.list.d/nodesource.list \
    && echo "deb-src https://deb.nodesource.com/$version $distro main" \
        | tee -a /etc/apt/sources.list.d/nodesource.list \
    && apt-get update \
    && apt-get install -qq nodejs --no-install-recommends \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*


# Node global tools

RUN npm install -g yarn ${NPM_GLOBAL_MODULES}


# Add entrypoint file that will perform run-time configuration before being deployed

COPY ./entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
