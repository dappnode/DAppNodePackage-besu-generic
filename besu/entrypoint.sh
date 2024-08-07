#!/bin/sh

# shellcheck disable=SC1091
. /etc/profile

JWT_PATH="/security/${NETWORK}/jwtsecret.hex"

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
