#!/bin/sh

set_network_specific_config() {
  echo "[INFO - entrypoint] Initializing $NETWORK specific config for client"

  set_consensus_dnp

  # If consensus client is prysm-prater.dnp.dappnode.eth --> CLIENT=prysm
  consensus_client=$(echo "$CONSENSUS_DNP" | cut -d'.' -f1 | cut -d'-' -f1)

  set_jwt_path "$consensus_client"
}

set_consensus_dnp() {
  uppercase_network=$(echo "$NETWORK" | tr '[:lower:]' '[:upper:]')
  consensus_dnp_var="_DAPPNODE_GLOBAL_CONSENSUS_CLIENT_${uppercase_network}"
  eval "CONSENSUS_DNP=\${$consensus_dnp_var}"
}

set_jwt_path() {
  consensus_client=$1
  echo "[INFO - entrypoint] Using $consensus_client JWT"
  JWT_PATH="/security/$consensus_client/jwtsecret.hex"

  if [ ! -f "${JWT_PATH}" ]; then
    echo "[ERROR - entrypoint] JWT not found at ${JWT_PATH}"
    exit 1
  fi
}

post_jwt_to_dappmanager() {
  echo "[INFO - entrypoint] Posting JWT to DAppManager"
  JWT=$(cat "${JWT_PATH}")

  curl -X POST "http://my.dappnode/data-send?key=jwt&data=${JWT}" || {
    echo "[ERROR - entrypoint] JWT could not be posted to package info"
  }
}

run_client() {
  echo "[INFO - entrypoint] Running client"

  exec besu --rpc-ws-enabled="${WS_ENABLED}" \
    --engine-jwt-secret="${JWT_PATH}" \
    --data-storage-format="${STORAGE_FORMAT}" \
    --sync-mode="${SYNC_MODE}" \
    --rpc-http-max-active-connections="${MAX_HTTP_CONNECTIONS}" \
    --p2p-port="${P2P_PORT}" \
    --network="${NETWORK}" \
    "${EXTRA_OPTS}"
}

set_network_specific_config
post_jwt_to_dappmanager
run_client
