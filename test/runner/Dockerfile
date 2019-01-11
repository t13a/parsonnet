ARG GCC_IMAGE=gcc
ARG GOLANG_IMAGE=golang
ARG DEBIAN_IMAGE=debian

FROM ${GCC_IMAGE} AS jsonnet-builder

ARG JSONNET_VERSION=0.12.1
ARG JSONNET_REPOSITORY=https://github.com/google/jsonnet

RUN git clone -qb "v${JSONNET_VERSION}" --depth 1 "${JSONNET_REPOSITORY}" /jsonnet && \
    cd /jsonnet && \
    make

FROM ${GOLANG_IMAGE} AS go-jsonnet-builder

ARG GO_JSONNET_VERSION=0.12.1
ARG GO_JSONNET_REPOSITORY=https://github.com/google/go-jsonnet

ARG COLOR_VERSION=1.7.0
ARG COLOR_PACKAGE="github.com/fatih/color@v${COLOR_VERSION}"

RUN git clone -qb "v${GO_JSONNET_VERSION}" --depth 1 "${GO_JSONNET_REPOSITORY}" /go-jsonnet && \
    cd /go-jsonnet && \
    go mod init github.com/google/go-jsonnet && \
    go mod edit -require "${COLOR_PACKAGE}" && \
    cd /go-jsonnet/jsonnet && \
    go build

FROM ${DEBIAN_IMAGE}

ARG SJSONNET_VERSION=0.1.2
ARG SJSONNET_JAR_URL="https://github.com/lihaoyi/sjsonnet/releases/download/${SJSONNET_VERSION}/sjsonnet.jar"

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    ca-certificates \
    curl \
    default-jre-headless \
    git \
    jq \
    time && \
    rm -rf /var/lib/apt/lists/* && \
    curl -sSL "${SJSONNET_JAR_URL}" --create-dirs -o /opt/sjsonnet/sjsonnet.jar && \
    chmod +x /opt/sjsonnet/sjsonnet.jar

COPY --from=jsonnet-builder /jsonnet/jsonnet /opt/jsonnet/jsonnet
COPY --from=go-jsonnet-builder /go-jsonnet/jsonnet/jsonnet /opt/go-jsonnet/jsonnet
COPY rootfs /

WORKDIR /parsonnet

CMD ["/parsonnet/test/run.sh"]
