latest_slot=$(curl -s https://cardano-preprod.blockfrost.io/api/v0/blocks/latest --header 'Project_id: preprod15FQAa3zauTfVwRuRNC2a0Z7Ho4rwigF' | jq .slot)
echo "Latest slot: $latest_slot"
echo "Future slot: $(($latest_slot+1000))"