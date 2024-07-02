#!/bin/sh

SUPPORTED_NETWORKS="holesky mainnet"

# shellcheck disable=SC1091
. /etc/profile

run_client() {
  echo "[INFO - entrypoint] Running client"

  # shellcheck disable=SC2086
  exec besu --rpc-ws-enabled="${WS_ENABLED}" \
    --engine-jwt-secret="${JWT_PATH}" \
    --data-storage-format="${STORAGE_FORMAT}" \
    --sync-mode="${SYNC_MODE}" \
    --rpc-http-max-active-connections="${MAX_HTTP_CONNECTIONS}" \
    --p2p-port="${P2P_PORT}" \
    --network="${NETWORK}" ${EXTRA_OPTS}
}

set_execution_config_by_network "${SUPPORTED_NETWORKS}"
post_jwt_to_dappmanager
run_client
