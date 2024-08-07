ARG UPSTREAM_VERSION

FROM hyperledger/besu:${UPSTREAM_VERSION}

ARG NETWORK
ARG P2P_PORT
ARG STAKER_SCRIPTS_VERSION
ARG DATA_DIR

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
    BESU_DATA_PATH=${DATA_DIR} \
    P2P_PORT=${P2P_PORT} \
    JWT_PATH=/jwtsecret.hex \
    STAKER_SCRIPTS_URL=https://github.com/dappnode/staker-package-scripts/releases/download/${STAKER_SCRIPTS_VERSION}

ADD ${STAKER_SCRIPTS_URL}/execution_tools.sh /etc/profile.d/

COPY entrypoint.sh /usr/local/bin/entrypoint.sh

USER root

# curl install throws error in ARM64 arch. It should not prevent build
RUN apt-get update && apt-get --no-install-recommends --yes install curl && apt-get clean || true

RUN mkdir ${DATA_DIR} && chown -R besu:besu ${DATA_DIR} && \
    chmod +rx /usr/local/bin/entrypoint.sh /etc/profile.d/execution_tools.sh

USER besu

# This env changes the variant
# Placed at the end to regenerate the least amount of layers
ENV NETWORK=${NETWORK}

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]