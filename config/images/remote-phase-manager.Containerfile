FROM registry.access.redhat.com/ubi9/ubi-minimal:latest

WORKDIR /

COPY remote-phase-manager /

# force Go to link against OpenSSL for FIPS compliance
ENV OPENSSL_FORCE_FIPS_MODE=1

USER "nobody"

ENTRYPOINT ["/remote-phase-manager"]
