#!/bin/bash

# Example usage within vim
# %! Operate.sh ls 
# %! Operate.sh find /usr/include/ -path "*/@@" 
cmd=$*
if ! echo ${cmd} | grep -q "@@" ; then
  cmd=${cmd}" @@"
fi

CMD=$( echo "${cmd}" | sed 's/@@/\"@@\"/g' )

xargs -I@@ bash -c "${CMD}"
