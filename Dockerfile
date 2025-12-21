FROM debian:bookworm-slim AS downloader

ARG KUBECTL_VERSION=v1.35.0
ARG KUBECTL_URL="https://dl.k8s.io/release/$KUBECTL_VERSION/bin/linux"

RUN \
    ARCH=$(uname -m) && \
    case $ARCH in \
        x86_64) ARCH=amd64 ;; \
        aarch64) ARCH=arm64 ;; \
        armv7l) ARCH=arm ;; \
        s390x) ARCH=s390x ;; \
        ppc64le) ARCH=ppc64le ;; \
        *) echo "Unsupported architecture: $ARCH" && exit 1 ;; \
    esac && \
    apt-get update && \
    apt-get install -y curl && \
    curl -fsSLO "$KUBECTL_URL/${ARCH}/kubectl" && \
    curl -fsSLO "$KUBECTL_URL/${ARCH}/kubectl.sha256" && \
    echo "$(cat kubectl.sha256)  kubectl" | sha256sum --check && \
    rm kubectl.sha256 && \
    chmod +x kubectl && \
    mv kubectl /usr/local/bin/kubectl

FROM debian:bookworm-slim

COPY --from=downloader /usr/local/bin/kubectl /usr/local/bin/kubectl
