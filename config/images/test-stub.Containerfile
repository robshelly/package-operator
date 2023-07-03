FROM registry.access.redhat.com/ubi8/ubi-minimal:latest

WORKDIR /
COPY test-stub /

# force Go to link against OpenSSL for FIPS compliance
ENV OPENSSL_FORCE_FIPS_MODE=1

USER "nobody"

ENTRYPOINT ["/test-stub"]
