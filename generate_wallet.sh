#!/bin/bash

DIR=$1

# Check if the argument is provided
if [ -z "$DIR" ]; then
    echo "Usage: $0 <directory>"
    exit 1
fi

if [ $# -eq 1 ]; then

    mkdir -p "keys/$DIR"
    cd "keys/$DIR" || exit

    cardano-wallet recovery-phrase generate --size 24 > "$DIR.mnemonic"
    cat "$DIR.mnemonic" | cardano-address key from-recovery-phrase Shelley > "$DIR.prv"

    cat "$DIR.prv" | cardano-address key child 1852H/1815H/0H/2/0 > "$DIR.staking.xprv"
    cat "$DIR.prv" | cardano-address key child 1852H/1815H/0H/0/0 > "$DIR.payment.xprv"

    cat "$DIR.payment.xprv" | cardano-address key public --with-chain-code | tee "$DIR.payment.xpub" | cardano-address address payment --network-tag 0 | cardano-address address delegation $(cat "$DIR.staking.xprv" | cardano-address key public --with-chain-code | tee "$DIR.staking.xpub") > "$DIR.payment.addr"

    SESKEY=$(cat "$DIR.staking.xprv" | bech32 | cut -b -128)$(cat "$DIR.staking.xpub" | bech32)
    PESKEY=$(cat "$DIR.payment.xprv" | bech32 | cut -b -128)$(cat "$DIR.payment.xpub" | bech32)

    cat <<EOF > "$DIR.staking.skey"
{
    "type": "StakeExtendedSigningKeyShelley_ed25519_bip32",
    "description": "",
    "cborHex": "5880$SESKEY"
}
EOF

    cat <<EOF > "$DIR.payment.skey"
{
    "type": "PaymentExtendedSigningKeyShelley_ed25519_bip32",
    "description": "Payment Signing Key",
    "cborHex": "5880$PESKEY"
}
EOF

    cardano-cli key verification-key --signing-key-file "$DIR.staking.skey" --verification-key-file "$DIR.staking.evkey"
    cardano-cli key verification-key --signing-key-file "$DIR.payment.skey" --verification-key-file "$DIR.payment.evkey"

    cardano-cli key non-extended-key --extended-verification-key-file "$DIR.payment.evkey" --verification-key-file "$DIR.payment.vkey"
    cardano-cli key non-extended-key --extended-verification-key-file "$DIR.staking.evkey" --verification-key-file "$DIR.staking.vkey"

fi