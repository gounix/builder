IMAGE=builder
IMAGE_VERSION=1.1.0
UBUNTU_VERSION=26.04

.PHONY: dockerhub

dockerhub:
	buildah build --build-arg UBUNTU_VERSION=${UBUNTU_VERSION} --build-arg BUILDER_VERSION=${IMAGE_VERSION} -t ${IMAGE}:${IMAGE_VERSION} .
	#buildah login docker.io
	buildah push ${IMAGE}:${IMAGE_VERSION} gounix/${IMAGE}:${IMAGE_VERSION}

