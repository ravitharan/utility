#!/bin/bash

# Example usage within vim
# %! Operate.sh ls 
# %! Operate.sh find /usr/include/ -path "*/@@" 

cmd=$*
if ! echo ${cmd} | grep -q "@@" ; then
  cmd=${cmd}" @@"
fi

cat /dev/stdin | xargs -I@@ bash -c "${cmd}"
