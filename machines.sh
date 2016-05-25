#!/bin/bash

IP_STEM="
137.58.48
137.58.49
137.58.50
137.58.51"

BlackList="
albatross
avocet
bittern
chough
greenfinch
grouse
merlin
pascal
skua
skylark
warbler
wigeon
137.58.49.44
137.58.48.1
137.58.48.2
137.58.48.3
137.58.48.4
137.58.48.5
137.58.48.6
137.58.48.7
137.58.48.8
137.58.48.9
137.58.48.10
137.58.48.11
137.58.48.17
137.58.48.20
137.58.49.12
137.58.49.44
137.58.49.146
137.58.49.173
"

FastMachines="
curlew
gull
osprey
137.58.49.15
137.58.49.8
137.58.49.18
137.58.49.129
137.58.50.15
137.58.50.8
137.58.49.165
137.58.49.155
137.58.50.3,6
"

#all=$( ls /v/space/ )
#rm -f machines.txt
#
#for m in ${all}
#do
#  if ! echo ${BlackList} | grep -q ${m}; then
#    if ssh -f ${m} "sleep 0.1" &> /dev/null
#    then
#      echo ${m} >> machines.txt
#    fi
#  fi
#done

if [ "$1" == "all" ]; then
  rm -f machines.csv
  for ip in ${IP_STEM}
  do
    for i in $( seq 255 )
    do
      m=${ip}.${i}
      if ! echo ${BlackList} | grep -q ${m}; then
        if ping -c 1 ${m} &> /dev/null; then
          echo ${m}
          if ssh -f ${m} "sleep 0.1" &> /dev/null; then
            echo "START ${m}" >> machines.csv
            ssh ${m} "cat /proc/cpuinfo; cat /proc/meminfo" >> machines.csv
            echo "END" >> machines.csv
          fi
        fi
      fi
    done
  done
  sed -i '/processor[ 	]*: [^0]/,/power management:/d' machines.csv
  sed -i '/MemFree:/,/END/d' machines.csv
  sed -i '/\(processor\|vendor_id\|stepping\|microcode\|bugs\|physical id\|core id\|apicid\|initial apicid\|fpu\|fpu_exception\|cpuid level\|wp\|flags\|clflush size\|cache_alignment\|address sizes\|power management\)/d' machines.csv
  sed -i '/^[ 	]*$/d' machines.csv
  sed -i 's/^.*:[ 	]*//g' machines.csv
  sed -i 's/[ 	]\+/ /g' machines.csv
  sed -i 's/[ 	]\+[kK]B//g' machines.csv
  sed -i ':a;N;$!ba;s/\n/,/g' machines.csv
  sed -i 's/START /\n/g' machines.csv
  sed -i 's/^$/machine,cpu_family,model,model_name,cpu_MHz,cache_size,siblings,cpu_cores,bogomips,memory/g' machines.csv
  soffice --calc machines.csv &
else
  rm -f /tmp/msg
  for m in ${FastMachines}
  do
    load=$( ssh ${m} "cat /proc/loadavg" )
    echo ${load} ${m} >> /tmp/msg
  done
  sort -V /tmp/msg
fi
