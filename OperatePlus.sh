#!/bin/bash
cmd=$*
if ! echo ${cmd} | grep -q "@@" ; then
  cmd=${cmd}" @@"
fi
while read ALine
do
#  echo $ALine
  CMD=$( echo ${cmd} | sed "s:@@:${ALine}:g")
#  echo ${CMD}
  ${CMD}
done
