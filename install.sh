#!/bin/bash

sudo apt update
sudo apt-get install -y binfmt-support qemu-user-static jq

mkdir -p ~/.docker/cli-plugins
BUILDX_URL=$(curl https://api.github.com/repos/docker/buildx/releases/latest | jq -r .assets[].browser_download_url | grep amd64)
wget $BUILDX_URL -O ~/.docker/cli-plugins/docker-build
chmod +x ~/.docker/cli-plugins/docker-buildx

docker buildx create --name xbuilder
docker buildx use xbuilder
docker buildx inspect --bootstrap