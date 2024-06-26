ARG UPSTREAM_VERSION
ARG NETWORK

FROM hyperledger/besu:${UPSTREAM_VERSION}

COPY security /security
COPY entrypoint.sh /usr/local/bin/entrypoint.sh

USER root

# curl install throws error in ARM64 arch. It should not prevent build
RUN apt update && apt install -y curl || true

RUN mkdir /var/lib/besu
RUN chown -R besu:besu /var/lib/besu

ENV BESU_RPC_WS_HOST=0.0.0.0 \
    BESU_RPC_HTTP_HOST=0.0.0.0 \
    BESU_RPC_HTTP_ENABLED=true \
    BESU_HOST_ALLOWLIST=* \
    BESU_RPC_HTTP_CORS_ORIGINS=* \
    BESU_ENGINE_RPC_PORT=8551 \
    BESU_ENGINE_HOST_ALLOWLIST=* \
    BESU_ENGINE_RPC_ENABLED=true \
    BESU_METRICS_ENABLED=true \
    BESU_METRICS_HOST=0.0.0.0 \
    BESU_DATA_PATH=/var/lib/besu \
    NETWORK=${NETWORK}

USER besu

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]