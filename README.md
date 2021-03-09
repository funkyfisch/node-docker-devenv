# node-docker-devenv

### Development environment in Docker for NodeJS
A full-fledged, dockerized NodeJS development environment, for keeping your
host machine as clean as possible.

[![funkyfisch](https://circleci.com/gh/funkyfisch/node-docker-devenv.svg?style=shield)](https://circleci.com/gh/funkyfisch/node-docker-devenv?branch=master)
![Docker Pulls](https://img.shields.io/docker/pulls/funkyfisch/node-docker-devenv)

## Building Image
```bash
# arguments are optional

docker build \
  --build-arg NODE_MAJOR_VERSION=14 \
  --build-arg NPM_GLOBAL_MODULES="grunt gulp eslint nodemon" \
  -t node-docker-devenv:latest .
```

## Running Container

Navigate to the directory that you want to work in.
You can use the script that provides all the needed arguments and options,
Export the variable DEV_PORT with a port that you would like. If not exported,
by default port 4000 will be used on the host (that will be mapped to 8080 inside the container)
Some development frameworks need an extra port in order to use live/hot reloading features
You can export the variable HOT_RELOAD_PORT with a port you would like. If not exported,
by default port 35729 will be used on both the host (that will be mapped to itself inside the
container)

```bash
DEV_PORT=9090
HOT_RELOAD_PORT=35729
/path/to/this/repo/start-devenv.sh
```

Optionally you can create a symbolic link to this script, to make it easier to spin up the
development environment from any place you like.

```bash
mkdir -p $HOME/.bin && ln -s /path/to/this/repo/start-devenv.sh $HOME/.bin/nodejs-devenv
export PATH="$HOME/.bin:$PATH"
```

Or you can copy this script into your $HOME/.bin folder and edit it from there if you need custom
functionality:

```bash
mkdir -p $HOME/.bin && cp /path/to/this/repo/start-devenv.sh $HOME/.bin/nodejs-devenv
export PATH="$HOME/.bin:$PATH"
```

If you need to provide extra options to your containers, go ahead and edit the script.

## Managing global npm modules

If you realize you needed another npm global module for your session, you can simply install it
without elevated priviledges, using

```bash
npm install -g module-name
```

If you wanted a global module to be permanently part of your image, but you did not add it during
the docker image build, you can do the following:

```bash
docker run \
  --env USER="${USER}" \
  -v /etc/passwd:/etc/passwd:ro \
  -v /etc/group:/etc/group:ro \
  -v /etc/timezone:/etc/timezone:ro \
  -v "${HOME}:/home/${USER}/" \
  --name "node-docker-devenv-install" \
  node-docker-devenv:latest \
  npm install -g global-module

docker commit node-docker-devenv-install node-docker-devenv:latest
```

This will take the base image you already created, start a container that then only installs
"global-module" globally, and then commits that modification on top of the existing base image.
You can do this as many times as you like, without fearing to commit any extra work/information
that might be present when you interactively use this image.


## Rationale

 * we don't want to keep containers - all work should be persisted either as part of the image or as
 part of the workspace
 * we want to login with the host user in order to have seamless experience with permissions and with the home directory being mounted. We need to make sure we use the same user *name* in host and container.
 The username is also used in the entrypoint script to source the .bashrc file.
 * a constant hostname is used so that we can tell immediatelly which shell we are on
 * mount the directory where this script is invoked from as our workspace for portability
 * mount group, passwd file so that we can resolve users and groups properly inside the container
 * mount timezone to make sure time related processes have consistent formatting
 * mount the entire home directory, mostly in order to make have our hidden folders available. Usually the hidden folders contain per-user metadata for tools and binaries. This way we also provide the ssh keys and global git configuration to able to use them inside the container.
