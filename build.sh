#!/bin/bash

if [ "$3" == "" ]; then
    echo "Usage build.sh <repo> <target> <platforms> <path in repo>"
    exit 1
fi

TEMP=$(mktemp -d)

cd $TEMP
git clone $1 ./

if [ "$4" != ""]; then
    cd "$4"
fi

awk '/FROM/ { print; print "LABEL org.opencontainers.image.source=https://github.com/meyskens/multiarch-docker-images"; next }1' Dockerfile

# Patches Bitnami with the official Debian
sed -i 's/docker.io\/bitnami\/minideb/docker.io\/debian/g' Dockerfile

docker buildx build --platform "$3" -t "$2:main" --push .

if [ "$(git tag -n)" != "" ]; then
    TAG=$(git describe --tags $(git rev-list --tags --max-count=1))
    if [ "$5" != "" ]; then
        TAG=$(git tag -n | grep "$5" | head -n 1)
    fi
    
    git checkout $TAG
    docker buildx build --platform "$(echo $3 | sed 's/:/,/g')" -t "$2:$TAG" --push .
fi
