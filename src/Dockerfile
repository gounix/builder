ARG UBUNTU_VERSION
ARG BUILDER_VERSION

FROM docker.io/ubuntu:${UBUNTU_VERSION}
ARG BUILDER_VERSION

RUN apt-get install --update -y git openssh-client make buildah ca-certificates containerd wget curl

RUN mkdir /root/.ssh
RUN mkdir /root/.ssh2

RUN mkdir -p /var/snap/microk8s/common/run
RUN mkdir -p /var/lib/containers

COPY ./build.sh /
RUN sed -i s/Development-version/${BUILDER_VERSION}/ /build.sh

CMD [ "/build.sh" ]
