cardano-cli address build --payment-script-file script.config --stake-verification-key-file keys/joe/joe.staking.vkey  --testnet-magic 1 > script.addr

cat script.addr
echo ""