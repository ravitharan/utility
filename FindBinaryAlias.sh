#!/bin/bash
if ! [ -d ./binaries ]; then
  echo "Need to run from ats root path, eg. ats/trunk"
  exit 1
fi
while read ALine
do
  if ! echo ${ALine} | grep -q "/binaries/" ; then
    echo ${ALine}
  else
    FileName=$( echo ${ALine} | sed "s:^.*/binaries/.*/\([^/]\+\)$:\1:g" )
    find ${PWD} -path ${PWD}/binaries -prune -o -name ${FileName} -print
  fi
done
