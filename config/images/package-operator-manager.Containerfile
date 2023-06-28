FROM registry.access.redhat.com/ubi8/ubi-minimal:latest

WORKDIR /

COPY passwd /etc/passwd
COPY package-operator-manager /

# force Go to link against OpenSSL for FIPS compliance
ENV OPENSSL_FORCE_FIPS_MODE=1

USER "noroot"

ENTRYPOINT ["/package-operator-manager"]
