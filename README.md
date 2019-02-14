# node-docker-devenv
### Development environment in docker for Node.js

## Building Image
```
docker build -f docker/Dockerfile \
    --build-arg USER_ID=`id -u` --build-arg GROUP_ID=`id -g` \
    -t node-dev .
```

## Running Container

Navigate to your node js codebase, and then :

```
docker run --rm -ti -v `pwd`:/home/node/app node-dev bash
```

Append any additional options (such as port mapping) as you need.
Instead of bash you can also directly run any of your npm scripts,
as defined on your package.json file.

```
docker run --rm -ti -v `pwd`:/home/node/app -p 8080:8080 node-dev npm test
```

## Features

### General
This image will provide you with docker containers based on a base node image.
A fully fledged nodejs development environment, which prevents literring your host machine from any installations. All you need is docker and a text editor/IDE!

### Volume mapping
This image will essentially create a user called "node" inside any containers, which will
hold your host users ID and group ID. With volume mapping all files in your current directory will be mapped to /home/node/app directory of the container, which means you can modify/add/remove files from either host or container side and it's immediately reflected. Having a user with the same IDs removes any potential ownership problems, since all modified files will have the same owner at all times.

### Global JS tools
By default, all containers from this image will have **nodemon**, **mocha**, **instanbul** and **grunt** installed as global modules. You can always edit the Dockerfile if you need something specific. 

### Flexible Node/NPM versions
By specifying an additional build argument, you can specify which node version you need.
Default is node 10.

```
docker build -f docker/Dockerfile \
    --build-arg USER_ID=`id -u` --build-arg GROUP_ID=`id -g` \
    --build-arg NODE_VERSION=10 \
    -t node-dev .
```

