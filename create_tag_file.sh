#!/bin/bash

if [ -z "$1" ]; then
  echo "Usage: $0 <files_project.txt>"
  exit 1
fi
my_name="create_tag_file.sh"
tag_utility_name="create_tag_data.py"
tag_data_utility=$( echo $0 | sed "s:${my_name}:${tag_utility_name}:g" )

ABS_TARGET=$( readlink -f $1 )
TARGET_PATH=$( dirname ${ABS_TARGET} )
stem=$( basename $1 .txt )
stem=${stem#files_}
TAG_FILE=${TARGET_PATH}/tags_${stem}
FUN_DATA_FILE=${TARGET_PATH}/func_${stem}

ctags -n -L $1 -f ${TAG_FILE}

grep ";\"	f" ${TAG_FILE} | sed 's/^\([^[:space:]]\+\)	\([^[:space:]]\+\)	\([[:digit:]]\+\);"	f.*$/\2 \3 \1/g' | sort -V -k1,1 -k2,2 | ${tag_data_utility} > ${FUN_DATA_FILE}


