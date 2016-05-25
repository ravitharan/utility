#!/bin/bash

##debug message
#echo "argc = $#, argv = $*"
#for ((i=0;i<$#;i++))
#do
#  echo "${i} = ${!i}"
#done

file_name=$(echo $3 | sed 's/^\(.*\)[[:space:]]\+(\(revision\|working\) \([[:alnum:]]\+\).*$/\1/g') #adtgdb/src/adtgdbcore       (revision 65582)
file_base_name=$( basename ${file_name} )
file_dir_name=$( dirname ${file_name} )
left_rev=$(echo $3 | sed 's/^\(.*\)[[:space:]]\+(\(revision\|working\) \([[:alnum:]]\+\).*$/\3/g') #adtgdb/src/adtgdbcore       (revision 65582)
right_rev=$(echo $5 | sed 's/^\(.*\)[[:space:]]\+(\(revision\|working\) \([[:alnum:]]\+\).*$/\3/g') #adtgdb/src/adtgdbcore       (revision 65582)
tmp_file=/tmp/svn_$(echo ${file_dir_name} | tr '/' '_')_
left_file=${tmp_file}${left_rev}_${file_base_name}
cp $6 ${left_file}
if [ ${right_rev} == "copy" ] ; then
  right_file=${file_name}
else
  right_file=${tmp_file}${right_rev}_${file_base_name}
  cp $7 ${right_file}
fi
vimdiff ${left_file} ${right_file}
