## Besu (Execution Client)

Welcome to the Besu Ethereum Execution Layer Client

There are now two RPC APIs in Execution Clients:

1. **Querying API (port 8545)**: Use this endpoint to query transactions on your node and connect to it with your web3 wallet.

2. **Engine API (port 8551)**: Use this endpoint to connect your Beacon Chain (Consensus Layer) client.

If your Execution Client is not connected to a Consensus Layer client, you won't be able to keep it synced, nor use it to query the blockchain, nor will you be able to connect your wallet to it!
