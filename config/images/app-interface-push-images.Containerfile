FROM registry.access.redhat.com/ubi8/ubi:latest

# Ubi ships with outdated go, install recent version directly from build system.
RUN dnf install -y \
  http://download.eng.bos.redhat.com/brewroot/vol/rhel-8/packages/golang/1.20.6/1.module+el8.9.0+19500+fa91430b/x86_64/golang-1.20.6-1.module+el8.9.0+19500+fa91430b.x86_64.rpm \
  http://download.eng.bos.redhat.com/brewroot/vol/rhel-8/packages/golang/1.20.6/1.module+el8.9.0+19500+fa91430b/x86_64/golang-bin-1.20.6-1.module+el8.9.0+19500+fa91430b.x86_64.rpm \
  http://download.eng.bos.redhat.com/brewroot/vol/rhel-8/packages/golang/1.20.6/1.module+el8.9.0+19500+fa91430b/noarch/golang-src-1.20.6-1.module+el8.9.0+19500+fa91430b.noarch.rpm \
  python3-pip make ncurses git podman gcc && \
  pip3 install pre-commit

WORKDIR /workdir

COPY . .

ENV CGO_ENABLED=1
