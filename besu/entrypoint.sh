#!/bin/sh

set_jwt_path() {
  CLIENT=$1
  echo "Using $CLIENT JWT"
  JWT_PATH="/security/$CLIENT/jwtsecret.hex"
}

set_network_specific_config() {
  CONSENSUS_DNP=$1
  P2P_PORT=$2

  echo "[INFO - entrypoint] Initializing $NETWORK specific config for client"

  # If consensus client is prysm-prater.dnp.dappnode.eth --> CLIENT=prysm
  CLIENT=$(echo "$CONSENSUS_DNP" | cut -d'.' -f1 | cut -d'-' -f1)

  set_jwt_path "$CLIENT"

}

case "$NETWORK" in
"holesky") set_network_specific_config "$_DAPPNODE_GLOBAL_CONSENSUS_CLIENT_HOLESKY" 30415 ;;
"mainnet") set_network_specific_config "$_DAPPNODE_GLOBAL_CONSENSUS_CLIENT_MAINNET" 30414 ;;
*)
  echo "Unsupported network: $NETWORK"
  exit 1
  ;;
esac

# Check if curl is installed (not installed in ARM64 arch)
if command -v curl >/dev/null 2>&1; then
  # Print the jwt to the dappmanager
  JWT=$(cat "${JWT_PATH}")
  curl -X POST "http://my.dappnode/data-send?key=jwt&data=${JWT}"
else
  echo "curl is not installed in ARM64 arch. Skipping the JWT post to package info."
fi

exec besu --rpc-ws-enabled="${WS_ENABLED}" \
  --engine-jwt-secret="${JWT_PATH}" \
  --data-storage-format="${STORAGE_FORMAT}" \
  --sync-mode="${SYNC_MODE}" \
  --rpc-http-max-active-connections="${MAX_HTTP_CONNECTIONS}" \
  --p2p-port="${P2P_PORT}" \
  --network="${NETWORK}" \
  "${EXTRA_OPTS}"
