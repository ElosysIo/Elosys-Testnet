#!/usr/bin/env bash

# You should run this first to reset the genesis block
# and wipe out all the fixtures. Then you should run
# reset-network-fixtures.sh

set -euo pipefail
cd "$(dirname "$0")"

(
    echo "Deleting fixtures"
    find . -name "__fixtures__" | xargs rm -rf
)

(
    echo "Regenerating genesis block"
    cd ../elosys-cli
    yarn start chain:genesisblock -a ElosysGenesisAccount

    echo ""
    echo "Copy the above block into `DEV_GENESIS` in elosys/src/defaultNetworkDefinitions.ts"
)
