#!/bin/bash

DIR=$1

# Check if the argument is provided
if [ -z "$DIR" ]; then
    echo "Usage: $0 <directory>"
    exit 1
fi

if [ $# -eq 1 ]; then

    cat keys/$DIR/$DIR.payment.addr | bech32 | cut -c 3-58
  
fi