FROM registry.access.redhat.com/ubi8/ubi-minimal:latest

RUN microdnf install -y \
  python3-pip make ncurses git go-toolset && \
  pip3 install pre-commit

WORKDIR /workdir

COPY . .
