FROM ubuntu:20.04

ARG NODE_MAJOR_VERSION=14
ARG NPM_GLOBAL_MODULES

SHELL ["/bin/bash", "-o", "pipefail", "-c"]


# We do not need exact versions, each user will have their own version of the environment
# hadolint ignore=DL3008
RUN export DEBIAN_FRONTEND=noninteractive \
  && apt-get -qq update \
  && apt-get -qq install \
    --no-install-recommends \
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
  && apt-get -qq clean \
  && rm -rf /var/lib/apt/lists/* \
  && ln -s python3 /usr/bin/python


# Install npm nodejs and yarn
# We do not need exact versions, each user will have their own version of the environment
# hadolint ignore=DL3008
RUN export DEBIAN_FRONTEND=noninteractive \
  && export APT_KEY_DONT_WARN_ON_DANGEROUS_USAGE=1 \
  && curl -sSL https://deb.nodesource.com/gpgkey/nodesource.gpg.key | apt-key add - \
  && version=node_${NODE_MAJOR_VERSION}.x \
  && distro="$(lsb_release -cs)" \
  && add-apt-repository -s "deb https://deb.nodesource.com/$version $distro main" \
  && apt-get -qq update \
  && apt-get -qq install \
    --no-install-recommends \
    nodejs \
  && apt-get -qq clean \
  && rm -rf /var/lib/apt/lists/*


# Set a global installation folder that requires no elevation

RUN mkdir /npm-global \
  && npm config set prefix "/npm-global"

# Node global tools
# We do not need exact versions, each user will have their own version of the environment
# hadolint ignore=DL3016
RUN npm install -g npm yarn ${NPM_GLOBAL_MODULES}


# Need to change permissions of /npm-global submodules

RUN chmod -R +777 /npm-global


# Add entrypoint file that will perform run-time configuration before being deployed

COPY ./entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
