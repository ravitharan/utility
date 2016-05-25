#!/bin/bash
cat /dev/stdin | sed -e "s/^.*://g" -e 's/\/$//g' -e 's/[[:space:]]*\\$//g' -e 's/^[[:space:]]\+//g' -e 's/[[:space:]]\+/\n/g' -e '/^[[:space:]]*$/d' | sort -Vu
