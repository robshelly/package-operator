FROM registry.access.redhat.com/ubi9-minimal:latest

RUN microdnf install -y \
  python3-pip make ncurses git go-toolset podman && \
  pip3 install pre-commit

WORKDIR /workdir

COPY . .
