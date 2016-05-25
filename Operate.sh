#!/bin/bash
while read ALine
do
  $* $ALine
done
