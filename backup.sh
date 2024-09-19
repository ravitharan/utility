#! /bin/bash

if [ -z ${DRIVE} ];then
    DRIVE="/dev/sda1"
fi

if [ -z ${FOLDER} ];then
    FOLDER="backup"
fi

if [[ "${EUID}" -ne "0" ]]; then
    echo "Error, script $0 need to be run with root previlage"
    exit 1
fi

res=$( mount | grep -P "${DRIVE}" )
if [ -z "${res}" ]; then
    echo "Error, partition "${DRIVE}" is not mounted"
    exit 1
fi

path=$( echo ${res} | awk '{ print $3 }' )

echo "rsync -av --delete /home/programmer/Documents ${path}/${FOLDER}/"
rsync -av --delete /home/programmer/Documents ${path}/${FOLDER}/

echo "rsync -av --delete /home/programmer/opensource ${path}/${FOLDER}/"
rsync -av --delete /home/programmer/opensource ${path}/${FOLDER}/

echo "rsync -av --delete /home/programmer/utility ${path}/${FOLDER}/"
rsync -av --delete /home/programmer/utility ${path}/${FOLDER}/

