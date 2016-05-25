#!/bin/bash

#Prepends="
#ACE/adt/adtapprun/
#ACE/adt/adtconsole/
#ACE/adt/adtgdb/
#ACE/adt/adtpa/
#ACE/adt/adtquery/
#ACE/adt/adtqueue/
#ACE/adt/adtserver/
#ACE/adt/adtstatus/
#ACE/adt/adtUartLib/
#ACE/bsp/libs/code/
#afwLib/code/
#afwLib/test/hcp/hmmLib/
#afwLib/test/hcp/pdiLib/
#afwLib/test/hcp/pdoLib/
#afwLib/test/hcp/umuxLib/
#"

Prepends="
adt/adtapprun/
adt/adtconsole/
adt/adtgdb/
adt/adtpa/
adt/adtquery/
adt/adtqueue/
adt/adtserver/
adt/adtstatus/
adt/adtUartLib/
adt/adtadmin/
adt/adtpoolserver/
adt/adtpool/
adt/adtmakecoredump/
adt/SpitfireDump/
bsp/libs/code/
afwLib/code/
afwLib/sf3/code/
afwLib/test/hcp/hmmLib/
afwLib/test/hcp/pdiLib/
afwLib/test/hcp/pdoLib/
afwLib/test/hcp/umuxLib/
iss/code/iss/objSf1-24/
iss/code/iss/objSf2-24/
iss/code/iss/objSf3-16/
iss/code/qcg/objSf120-24/
iss/code/qcg/objSf220-24/
iss/code/qcg/objSf320-16/
sfSim/code/sfSim/objSf3/
"
Temp=$( mktemp )
Folders=$(find -type f -name "*.d" | cut -b 3- | sed 's:[^/]\+$::g' | sort -Vu )
for i in ${Folders}
do
  FileName=$( echo ${i} | tr '/' '_' )files.txt
  find ${i} -name "*.d" | xargs cat > ${Temp}
  sed -i -e "s/^.*://g" -e 's/\/$//g' -e 's/[[:space:]]*\\$//g' -e 's/^[[:space:]]\+//g' -e 's/[[:space:]]\+/\n/g' -e '/^[[:space:]]*$/d' ${Temp}
  sort -Vu ${Temp} >  ${FileName}	

  for j in ${Prepends}
  do
    if echo ${i} | grep -q ${j} ; then
      sed -i -e "s:^[^/]:${j}&:g" ${FileName}
    fi
#remove objSf.* path from iss codes	
#    if echo ${i} | grep -q "/objSf[^/]\+" ; then
#      sed -i -e "s:/objSf[^/]\+::g" ${FileName}
#    fi
  done
done

rm ${Temp}

