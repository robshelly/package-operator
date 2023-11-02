FROM registry.access.redhat.com/ubi9/ubi-minimal:latest

RUN microdnf install -y diffutils

WORKDIR /

COPY kubectl-package /

# force Go to link against OpenSSL for FIPS compliance
ENV OPENSSL_FORCE_FIPS_MODE=1

ENTRYPOINT ["/kubectl-package"]
