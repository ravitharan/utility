#!/bin/bash
#svn -v st | grep "^[ MA]" | grep -o '[^\( 	\)]\+$' | xargs ls -ld | grep -v "^[ld]" | grep -o '[^\( 	\)]\+$' 
for file in $( svn -v st | grep "^[ MA]" | sed 's/^.\{7\}[[:space:][:digit:]]\+[[:space:][:digit:]]\+[^[:space:]]\+[[:space:]]\+//g' )
do
  [ -f "${file}" ] && echo "${file}"
done

