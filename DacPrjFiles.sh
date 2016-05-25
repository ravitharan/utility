#!/bin/bash

for i in $( ls *.o)
do
  objdump -D ${i} &> /dev/null
  if [ $? == 0 ]; then
    cat "${i%.o}.d" >> hcp_.txt
  else
    cat "${i%.o}.d" >> cpu_.txt
  fi
done

cat hcp_.txt | ~/ProjFiles.sh > hcpfiles.txt
cat cpu_.txt | ~/ProjFiles.sh > files.txt

rm -f hcp_.txt cpu_.txt
