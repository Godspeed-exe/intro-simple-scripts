## Intro into Cardano simple scripts

### Installation

1. get all prerequisites

bech32 & cardano-cli & cardano-wallet

``` 
wget https://github.com/cardano-foundation/cardano-wallet/releases/download/v2025-01-09/cardano-wallet-v2025-01-09-linux64.tar.gz
tar -xvf cardano-wallet-v2025-01-09-linux64.tar.gz
rm cardano-wallet-v2025-01-09-linux64.tar.gz
cd cardano-wallet-v2025-01-09-linux64
mv * /usr/local/bin/ 
``` 

Clone the scripts

``` 
git clone https://github.com/Godspeed-exe/intro-simple-scripts.git
cd intro-simple-scripts
chmod +x *.sh
``` 

### Usage

#### Generate wallets

``` 
./wallet.sh
this removes the 'keys' folder, re-makes it and generates Joe + Alice + Bob + Charlie wallets. It starts from a mnemonic and derives all the keys and addresses
``` 

#### Manually fill the script.config file
This file contains the spending logic, there is 2 sections.
This can be expanded with more signatures in the multi sig section, this could also be made more complex by adding a spending time (by using  'after' / 'before').

1. the main single spender (in our example this is Joe)
2. the multi sig spending (in our example this is Alice + Bob + Charlie)

#### Generate script.addr

Based on the script.config file this will generate a script address with Joe's stake key. This means that Joe will still keep full control over:
- where his ADA is staked
- which Drep his ADA is delegated to

``` 
./compile_script_address.sh
``` 

#### Spending - WORK IN PROGRESS