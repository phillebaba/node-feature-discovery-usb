.PHONY: all

VERSION := $(shell git describe --tags --always --dirty)

IMAGE_REGISTRY := "phillebaba"
IMAGE_NAME := "node-feature-discovery-usb"
IMAGE_TAG_NAME := $(VERSION)
IMAGE_REPO := $(IMAGE_REGISTRY)/$(IMAGE_NAME)
IMAGE_TAG := $(IMAGE_REPO):$(IMAGE_TAG_NAME)

PLATFORMS := "linux/amd64,linux/arm64,linux/arm"

all: image

image:
	@docker build -t $(IMAGE_TAG) .

push:
	@docker run --rm --privileged multiarch/qemu-user-static --reset -p yes
	@docker buildx create --use --name cross --platform $(PLATFORMS) --node cross0
	@docker buildx build --platform $(PLATFORMS) -t $(IMAGE_TAG) --push .
