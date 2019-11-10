#!/bin/bash
#cat /dev/stdin | sed -e "s/^.*://g" -e 's/\/$//g' -e 's/[[:space:]]*\\$//g' -e 's/^[[:space:]]\+//g' -e 's/[[:space:]]\+/\n/g' -e '/^[[:space:]]*$/d' | sort -Vu
cat /dev/stdin | sed -e 's;\x0d$;;g' -e 's; \\$;;g' -e 's;[[:space:]]\+;\n;g' -e '/^.*:$/d' -e 's;\\;/;g' -e 's;^.[cC]:/;/cygdrive/c/;g' | sort -Vu
