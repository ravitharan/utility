#!/bin/bash
if echo $5 | grep -q "(working copy)" ; then
  src_file=$(echo $3 | sed 's/[ 	]\+.*$//g')
  vimdiff $6 ${src_file}
else 
  vimdiff $6 $7
fi
