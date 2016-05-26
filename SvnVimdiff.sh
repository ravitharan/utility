#!/bin/bash


##debug message
#echo "argc = $#, argv = $*"
#for ((i=1;i<=$#;i++))
#do
#  echo ${i} = "${!i}"
#done

#Example usage:
#$ svn diff adt/adtcommon/src/adtMessages.h https://svn.etv.eld.ericsson.se/spitfire/ats/working/radrgr/335191/adt/adtcommon/src/adtMessages.h
#argc = 7, argv = -u -L adt/adtcommon/src/adtMessages.h  (https://svn.etv.eld.ericsson.se/spitfire/ats/working/radrgr/335191/adt/adtcommon/src/adtMessages.h)    (working copy) -L https://svn.etv.eld.ericsson.se/spitfire/ats/working/radrgr/335191/adt/adtcommon/src/adtMessages.h       (revision 65653) /tmp/svn-o1dt2Q /tmp/svn-J9f01e
#1 = -u
#2 = -L
#3 = adt/adtcommon/src/adtMessages.h     (https://svn.etv.eld.ericsson.se/spitfire/ats/working/radrgr/335191/adt/adtcommon/src/adtMessages.h)    (working copy)
#4 = -L
#5 = https://svn.etv.eld.ericsson.se/spitfire/ats/working/radrgr/335191/adt/adtcommon/src/adtMessages.h  (revision 65653)
#6 = /tmp/svn-o1dt2Q
#7 = /tmp/svn-J9f01e


file_name=$(echo $3 | sed 's/^\([^(]\+\)[[:space:]]\+(\(revision\|working\|http\).*[[:space:]]\([[:alnum:]]\+\))[[:space:]]*$/\1/g')
file_base_name=$( basename ${file_name} )
file_dir_name=$( dirname ${file_name} )
left_rev=$(echo $3 | sed 's/^\([^(]\+\)[[:space:]]\+(\(revision\|working\|http\).*[[:space:]]\([[:alnum:]]\+\))[[:space:]]*$/\3/g')
right_rev=$(echo $5 | sed 's/^\([^(]\+\)[[:space:]]\+(\(revision\|working\|http\).*[[:space:]]\([[:alnum:]]\+\))[[:space:]]*$/\3/g')
tmp_file=/tmp/svn_$(echo ${file_dir_name} | tr '/' '_')_
left_file=${tmp_file}${left_rev}_${file_base_name}

if [ ${left_rev} == "copy" ] ; then
  left_file=${file_name}
else
  left_file=${tmp_file}${left_rev}_${file_base_name}
  cp $6 ${left_file}
fi

if [ ${right_rev} == "copy" ] ; then
  right_file=${file_name}
else
  right_file=${tmp_file}${right_rev}_${file_base_name}
  cp $7 ${right_file}
fi
vimdiff ${left_file} ${right_file}
