FROM ubuntu:20.04

ENV DEBIAN_FRONTEND noninteractive
ARG NODE_MAJOR_VERSION=14
ARG NPM_GLOBAL_MODULES

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# We do not need exact versions, each user will have their own version of the environment
# hadolint ignore=DL3008
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
# We do not need exact versions, each user will have their own version of the environment
# hadolint ignore=DL3008
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


# Set a global installation folder that requires no elevation

RUN mkdir /npm-global \
    && chmod +777 /npm-global \
    && npm config set prefix "/npm-global"

# Node global tools
# We do not need exact versions, each user will have their own version of the environment
# hadolint ignore=DL3016
RUN npm install -g yarn ${NPM_GLOBAL_MODULES}


# Add entrypoint file that will perform run-time configuration before being deployed

COPY ./entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
