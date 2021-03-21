# multiarch-docker-images
A collection of single arch Docker images modified to be multiarch.
This repo will fetch all repos from `image-list` then uses Docker's buildx to compile them for amd64, arm64 and arm32v7 to publish then on ghcr.io for use in multiarch clusters. 

I built this for my own use as many container images I wanted to install were amd64 only even in 2021, this repo aims to make my life easy by automatically building the latest updates from the main branch as well as the latest tag to have a drop in replacement to use.
