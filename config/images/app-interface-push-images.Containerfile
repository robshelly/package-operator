FROM registry.access.redhat.com/ubi9/ubi-minimal:latest

RUN microdnf install -y \
  python3-pip make ncurses git go-toolset podman gcc && \
  pip3 install pre-commit

WORKDIR /workdir

COPY . .

ENV CGO_ENABLED=1

