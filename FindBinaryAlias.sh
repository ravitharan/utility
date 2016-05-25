#!/bin/bash
if [ $# == 0 ]; then
  echo "Source path not specified"
  exit 1
fi
while read ALine
do
  if ! echo ${ALine} | grep -q "/binaries/" ; then
    echo ${ALine}
  else
    FileName=$( echo ${ALine} | sed "s:^.*/binaries/.*/\([^/]\+\)$:\1:g" )
    find $1 -name ${FileName}
  fi
done
