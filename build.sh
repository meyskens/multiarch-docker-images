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

docker buildx build --platform "$3" -t "$2:main" --push .

if [ "$(git tag -n)" != "" ]; then
    TAG=$(git describe --tags $(git rev-list --tags --max-count=1))
    git checkout $TAG
    docker buildx build --platform "$3" -t "$2:$TAG" --push .
fi
