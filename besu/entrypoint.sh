#!/bin/sh

# shellcheck disable=SC1091
. /etc/profile

JWT_SECRET=$(get_jwt_secret_by_network "${NETWORK}")
echo "${JWT_SECRET}" >"${JWT_PATH}"

post_jwt_to_dappmanager "${JWT_PATH}"

echo "[INFO - entrypoint] Running client"

# shellcheck disable=SC2086
exec besu --rpc-ws-enabled="${WS_ENABLED}" \
  --rpc-ws-host='0.0.0.0' \
  --rpc-http-host='0.0.0.0' \
  --rpc-http-enabled=true \
  --rpc-max-logs-range="${RPC_MAX_LOGS_RANGE}" \
  --host-allowlist=* \
  --rpc-http-cors-origins=* \
  --rpc-ws-port=8546 \
  --engine-jwt-secret="${JWT_PATH}" \
  --data-storage-format="${STORAGE_FORMAT}" \
  --sync-mode="${SYNC_MODE}" \
  --rpc-http-max-active-connections="${MAX_HTTP_CONNECTIONS}" \
  --p2p-port="${P2P_PORT}" \
  --metrics-enabled=true \
  --metrics-host='0.0.0.0' \
  --network="${NETWORK}" ${EXTRA_OPTS}
