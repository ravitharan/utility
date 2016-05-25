#!/bin/bash

Terminate=0
trap "Terminate=1" SIGINT SIGTERM
echo "pid is $$"

while :     # This is the same as "while true".
do
  /opt/spitfire/pack/adt/poolserver/adtpoolserverd -config /opt/spitfire/manifest/poolserver.json
  if [ ${Terminate} == 1 ] ; then
    echo "Terminated by user"
    break;
  else
    echo "Server unexpectedly died."
  fi
done

