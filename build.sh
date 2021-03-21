#!/bin/bash

if [ "$2" == ""]; then
    echo "Usage build.sh <repo> <target> <path in repo>"
    exit 1
fi

TEMP=$(mktemp -d)

cd $TEMP
git clone $1 ./

if [ "$3" != ""]; then
    cd "$3"
fi

awk '/FROM/ { print; print "LABEL org.opencontainers.image.source=https://github.com/meyskens/multiarch-docker-images"; next }1' Dockerfile

docker buildx build --platform "linux/amd64,linux/arm64,linux/arm" -t "$2:main" --push .

if [ "$(git tag -n)" != "" ]; then
    TAG=$(git describe --tags $(git rev-list --tags --max-count=1))
    git checkout $TAG
    docker buildx build --platform "linux/amd64,linux/arm64,linux/arm" -t "$2:$TAG" --push .
f