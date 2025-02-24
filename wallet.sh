rm -rf -- keys && mkdir -p -- keys && touch keys/.gitkeep || exit
./generate_wallet.sh joe && ./generate_wallet.sh alice && ./generate_wallet.sh bob && ./generate_wallet.sh charlie

echo "Joe":
./get_pubkey_hash.sh joe
echo "Alice":
./get_pubkey_hash.sh alice
echo "Bob":
./get_pubkey_hash.sh bob
echo "Charlie":
./get_pubkey_hash.sh charlie