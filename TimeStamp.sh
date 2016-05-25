#!/bin/bash
OFFSET=1363692396
while read line ; 
do
  t=$( date +%s )
  t=$(( ${t} -${OFFSET} ))
  printf "%04d:%s\n" ${t} "${line}"
done
