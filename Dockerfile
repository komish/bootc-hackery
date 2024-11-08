# This should come from GitHub Actions
ARG CI_BUILD_URL=unknown
ARG CI_BUILD_TRIGGER=unknown
ARG CI_BUILD_REF=unknown
ARG CI_BUILD_SOURCE_COMMIT=unknown

FROM quay.io/fedora/fedora-bootc:latest

ARG CI_BUILD_URL
ARG CI_BUILD_TRIGGER
ARG CI_BUILD_REF 
ARG CI_BUILD_SOURCE_COMMIT

RUN dnf update -y && dnf clean all

RUN echo BUILD_DATE="$(date)" > /etc/ci-meta \
    && echo BUILD_URL="${CI_BUILD_URL}" >> /etc/ci-meta \
    && echo BUILD_TRIGGER="${CI_BUILD_TRIGGER}" >> /etc/ci-meta \
    && echo BUILD_REF="${CI_BUILD_REF}" >> /etc/ci-meta \
    && echo BUILD_SOURCE_COMMIT="${CI_BUILD_SOURCE_COMMIT}" >> /etc/ci-meta

## Below is cleaner than the above, but buildah-build in GitHub Actions
## doesn't like this heredoc usage for some reason.

# RUN cat > /etc/ci-meta <<EOF
# BUILD_DATE=$(date)
# BUILD_URL=${CI_BUILD_URL}
# BUILD_TRIGGER=${CI_BUILD_TRIGGER}
# BUILD_REF=${CI_BUILD_REF}
# BUILD_SOURCE_COMMIT=${CI_BUILD_SOURCE_COMMIT}
# EOF

COPY build-meta /usr/local/bin/build-meta