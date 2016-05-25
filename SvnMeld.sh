#!/bin/bash
if echo $5 | grep -q "(working copy)" ; then
  src_file=$(echo $3 | sed 's/[ 	]\+.*$//g')
  meld $6 ${src_file}
else 
  meld $1 $2 "$3" $4 "$5" $6 $7
fi
