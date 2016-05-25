#!/bin/bash
svn -v st | grep "^[ MA]" | grep -o '[^\( 	\)]\+$' | xargs ls -ld | grep -v "^[ld]" | grep -o '[^\( 	\)]\+$' 
