#!/bin/bash
TEMP_FILE=`mktemp`
cat /dev/stdin > ${TEMP_FILE}
cat ${TEMP_FILE} | grep "^ \{16\}0x[[:xdigit:]]\{16\} \{16\}[^\([:digit:]+\-\*/\.\)][^\(\-\'[:space:]\)]*$" | sed "s/^[ 	]\+0x0\{8\}//g" | sed "s/[ 	]\+/ /g"
#cat /dev/stdin | grep "^[[:xdigit:]]\{8,16\} [tT] [^\([:digit:]+\-\*/\.\)][^\(\-\'[:space:]\)]*$" | sed "s/ [tT] / /g" 
cat ${TEMP_FILE} | grep "^[[:xdigit:]]\{8\} [tT] " | sed "s/ [tT] / /g"
rm ${TEMP_FILE}
