#!/bin/bash

# Step 1: Query UTXOs from script address
cardano-cli query utxo --address $(cat script.addr) --testnet-magic 1 --out-file utxo.json

tx_in=""
total_lovelace=0

# Step 2: Extract UTXOs from JSON
while read -r utxo; do
    amount=$(jq -r --arg utxo "$utxo" '.[$utxo].value.lovelace' utxo.json)
    tx_in+=" --tx-in ${utxo}"
    total_lovelace=$((total_lovelace + amount))
done < <(jq -r 'keys[]' utxo.json)

# Step 3: Fetch latest slot & set invalid-hereafter
latest_slot=$(curl -s https://cardano-preprod.blockfrost.io/api/v0/blocks/latest --header 'Project_id: preprod15FQAa3zauTfVwRuRNC2a0Z7Ho4rwigF' | jq .slot)
invalid_hereafter=$(($latest_slot+10000))



# Step 8: Build the **final transaction**
cardano-cli conway transaction build \
    --invalid-hereafter "$invalid_hereafter" \
    $tx_in \
    --tx-in-script-file script.config \
    --change-address $(cat script.addr) \
    --testnet-magic 1 \
    --out-file spendScriptTxBody


cardano-cli conway transaction witness \
    --tx-body-file spendScriptTxBody \
    --signing-key-file keys/joe/joe.payment.skey \
    --testnet-magic 1 \
    --out-file joeWitness


# cardano-cli conway transaction witness \
#     --tx-body-file spendScriptTxBody \
#     --script-file script.config \
#     --testnet-magic 1 \
#     --out-file scriptWitness


cardano-cli conway transaction assemble \
    --tx-body-file spendScriptTxBody \
    --witness-file joeWitness \
    --out-file spendMultiSig

# Step 12: Submit the transaction
cardano-cli conway transaction submit --testnet-magic 1 --tx-file spendMultiSig

echo "Transaction submitted successfully!"