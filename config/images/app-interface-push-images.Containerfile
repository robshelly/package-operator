FROM registry.access.redhat.com/ubi9/ubi:latest

ENV CGO_ENABLED=1 GOPROXY="https://proxy.golang.org" GOSUMDB="sum.golang.org"

# Ubi ships with outdated go, install recent version directly from build system.
RUN dnf install -y python3-pip make ncurses git podman gcc \
  http://download.devel.redhat.com/brewroot/vol/rhel-9/packages/golang/1.22.2/1.el9/x86_64/golang-1.22.2-1.el9.x86_64.rpm \
  http://download.devel.redhat.com/brewroot/vol/rhel-9/packages/golang/1.22.2/1.el9/x86_64/golang-bin-1.22.2-1.el9.x86_64.rpm \
  http://download.devel.redhat.com/brewroot/vol/rhel-9/packages/golang/1.22.2/1.el9/x86_64/go-toolset-1.22.2-1.el9.x86_64.rpm \
  http://download.devel.redhat.com/brewroot/vol/rhel-9/packages/golang/1.22.2/1.el9/noarch/golang-src-1.22.2-1.el9.noarch.rpm && \
  pip3 install pre-commit

# From https://github.com/containers/image_build/blob/83ee6dd5242eec6a86caeb70b3559f9af0c9adaa/podman/stable/Containerfile#L28,L30
ARG _REPO_URL="https://raw.githubusercontent.com/containers/image_build/83ee6dd5242eec6a86caeb70b3559f9af0c9adaa/podman/stable"
ADD $_REPO_URL/containers.conf /etc/containers/containers.conf
ADD $_REPO_URL/podman-containers.conf /home/podman/.config/containers/containers.conf

WORKDIR /workdir

COPY . .
