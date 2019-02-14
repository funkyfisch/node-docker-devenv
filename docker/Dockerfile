# Dockerfile for development environment of nodejs
# containers and services. It can be used for any nodejs
# based environments.

# Development environment needs a more elaborate setup with user
# permissions, since there are files being modified/created by
# both the container and the host. Therefore the development image
# is created with setting "node" as a user with the same UID as
# the host user running the container.

# Arguments passed to image. If not passed, defaults are used

ARG GROUP_ID
ARG USER_ID
ARG NODE_VERSION=10

# Base node image. Version is determined from argument

FROM node:${NODE_VERSION}

# Environment setup

ENV NPM_CONFIG_PREFIX=/home/node/.npm-global
ENV PATH=$PATH:/home/node/.npm-global/bin
ENV NODE_ENV="development"


# Enforce the passing of specific build-time parameters

RUN  : "${GROUP_ID:?USER_ID:?Build argument needs to be \
    set and non-empty.}"

# Get rid of the default node user if the host user id is not
# already 1000. Will be recreated with custom UID later.
# For more info, read : https://goo.gl/y1a3mM

RUN if [ $USER_ID != "1000" ] \
    ;then \
      userdel -f node && \
      if getent group node; then groupdel node; fi && \
      groupadd -g ${GROUP_ID} node && \
      useradd -l -u ${USER_ID} -g node node && \
      install -d -m 0755 -o node -g node /home/node \
    ;else \
      echo "Keeping default user node" \
    ;fi

# Re acquire ownership of folders and files belonging to original node

RUN if [ $USER_ID != "1000" ] \
    ;then \
      chown --changes --recursive --no-dereference \
      --from=1000:1000 ${USER_ID}:${GROUP_ID} \
      /home/node \
    ;else \
      echo "Not changing ownership" \
    ; fi

# NPM global configuration

RUN npm config set strict-ssl false -g \
    && npm config set registry http://registry.npmjs.org/ -g \
    && npm config set maxsockets 1 -g \
    && npm config set fetch-retry-mintimeout 2000 -g \
    && npm config set fetch-retry-maxtimeout 8000 -g

# Confirm environment before running any installations

RUN echo $http_proxy && echo npm config list

# Helpful tools

RUN apt-get update && apt-get install -y nano

# NPM global tools installation :
# nodemon for development,
# mocha for testing,
# istanbul for code coverage,
# vue-cli for client front ent development
# Installation is done in steps so as not
# to saturate the network with requests

RUN npm install nodemon -g --verbose \
    && npm install mocha -g --verbose \
    && npm install istanbul -g --verbose \
    && npm install grunt -g --verbose \
    && npm install vue-cli -g --verbose

# Switch to the non-root node user and the app base dir

USER node
RUN mkdir /home/node/app
WORKDIR /home/node/app

# Declare entrypoint command

CMD ["npm", "start"]
