FROM registry.access.redhat.com/ubi9/ubi:latest

ENV CGO_ENABLED=1 GOPROXY="https://proxy.golang.org" GOSUMDB="sum.golang.org"

# Ubi ships with outdated go, install recent version directly from build system.
RUN dnf install -y python3-pip make ncurses git podman gcc \
  http://download.eng.bos.redhat.com/brewroot/vol/rhel-9/packages/golang/1.21.7/1.el9/x86_64/golang-1.21.7-1.el9.x86_64.rpm \
  http://download.eng.bos.redhat.com/brewroot/vol/rhel-9/packages/golang/1.21.7/1.el9/x86_64/golang-bin-1.21.7-1.el9.x86_64.rpm \
  http://download.eng.bos.redhat.com/brewroot/vol/rhel-9/packages/golang/1.21.7/1.el9/x86_64/go-toolset-1.21.7-1.el9.x86_64.rpm \
  http://download.eng.bos.redhat.com/brewroot/vol/rhel-9/packages/golang/1.21.7/1.el9/noarch/golang-src-1.21.7-1.el9.noarch.rpm && \
  pip3 install pre-commit

ARG _REPO_URL="https://raw.githubusercontent.com/containers/podman/main/contrib/podmanimage/stable"
ADD $_REPO_URL/containers.conf /etc/containers/containers.conf
ADD $_REPO_URL/podman-containers.conf /home/podman/.config/containers/containers.conf

WORKDIR /workdir

COPY . .
