#!/bin/bash


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
  for m in $( ls /v/space )
  do
    if ! echo ${BlackList} | grep -q ${m}; then
      if ping -c 1 ${m} &> /dev/null; then
        echo ${m}
        if timeout -s SIGKILL 2 ssh -f ${m} "sleep 0.1" &> /dev/null; then
          echo "START ${m}" >> machines.csv
          ssh ${m} "cat /proc/cpuinfo; cat /proc/meminfo" >> machines.csv
          echo "END" >> machines.csv
        fi
      fi
    fi
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
