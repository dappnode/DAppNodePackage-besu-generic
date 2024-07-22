#!/bin/sh

SUPPORTED_NETWORKS="holesky mainnet"

# shellcheck disable=SC1091
. /etc/profile

JWT_PATH=$(get_jwt_path "${NETWORK}" "${SUPPORTED_NETWORKS}" "${SECURITY_PATH}")

post_jwt_to_dappmanager "${JWT_PATH}"

echo "[INFO - entrypoint] Running client"

# shellcheck disable=SC2086
exec besu --rpc-ws-enabled="${WS_ENABLED}" \
  --engine-jwt-secret="${JWT_PATH}" \
  --data-storage-format="${STORAGE_FORMAT}" \
  --sync-mode="${SYNC_MODE}" \
  --rpc-http-max-active-connections="${MAX_HTTP_CONNECTIONS}" \
  --p2p-port="${P2P_PORT}" \
  --network="${NETWORK}" ${EXTRA_OPTS}
