#!/bin/bash

if [ $# != 2 ]; then
  echo "Argument error"
  echo "Usage: $0 <TwikiUserName> <TwikiPassWord>"
  exit 1
fi
StartDate="Jan 01 2014"
EndDate="Jan 01 2015"
UserName=$1
PassWord=$2
StartSec=$( date +%s --date="${StartDate}" )
EndSec=$( date +%s --date="${EndDate}" )
CurrentSec=$( date +%s )
StartDaysBack=$( echo "(${CurrentSec} - ${StartSec})/(24*3600)" | bc )
EndDaysBack=$( echo "(${CurrentSec} - ${EndSec})/(24*3600)" | bc )
TimeSheetFile="/tmp/TimeSheet.html"
rm -f ${TimeSheetFile}
for d in $( seq ${StartDaysBack} -7 ${EndDaysBack} )
do
  days=$( echo "(${d}/7)*7" | bc )
  date=$(date -d"sunday-${days} days" +%y%m%d)
  echo "Timesheet ${date}"
  echo "<h2>Timesheet ${date} </h2>" >> ${TimeSheetFile}
  file=$( wget --post-data="username=${UserName}&password=${PassWord}&origurl=%2Fbin%2Fview%2FSqlTracking%2FTimesheet${UserName}${date}" http://twiki/bin/login/SqlTracking/Timesheet${UserName}${date} 2>&1 | grep "^Saving to:" | grep -o "Timesheet[[:alnum:]]\+" )
  if [ $? == 0 ] ; then
    sed -n '/Achievements/,/twikiContentFooter/p' ${file}  >> ${TimeSheetFile}
  fi
done
iceweasel ${TimeSheetFile} &

