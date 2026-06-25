#!/bin/bash

if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <board>"
    exit 1
fi

BOARD="$1"
date_str=$(date '+%Y-%m-%d %H:%M:%S')
echo "petalinux" | ssh -t ${BOARD} "sudo -S date -s \"$date_str\""
ssh ${BOARD}
