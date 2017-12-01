#!/bin/bash

currentZone=$(sudo systemsetup -gettimezone | sed -e 's/Time Zone://g' -e 's/.*[/]//' -e 's/_/ /g')
currentDate=$(date +'%a %d %b %H:%M %p')
timeZones="America/Los_Angeles America/Vancouver 	America/Winnipeg America/New_York Europe/London Europe/Paris Asia/Kolkata Asia/Bangkok Asia/Kuala_Lumpur Australia/Brisbane Australia/Melbourne Pacific/Auckland"

echo $currentDate',' $currentZone
echo '---'
for zone in $timeZones;
do
  currentD=$(date +%j:%H:%M)
  IFS=":"
  set -- $currentD
  cD=10#$1
  currentDy=$(($cD*1440))
  cH=10#$2
  currentHr=$(($cH*60))
  currentMin=10#$3
  currentTotalmins=$((currentDy+currentHr+currentMin))
  currentTotalHours=$(($currentTotalmins/60))

  zoneD=$(TZ=$zone date +%j:%H:%M)
  IFS=":"
  set -- $zoneD
  zD=10#$1
  zoneDy=$(($zD*1440))
  zH=10#$2
  zoneHr=$(($zH*60))
  zoneMin=10#$3
  zoneTotalmins=$((zoneDy+zoneHr+zoneMin))
  zoneTotalHours=$(($zoneTotalmins/60))

  zoneDifference=$(expr $zoneTotalHours - $currentTotalHours)
  zoneDifferenceMin=$(expr $zoneTotalmins - $currentTotalmins)
  zoneDifferenceMinComa=$(echo $zoneDifferenceMin | sed -e 's/.\{2\}$/:&/g')

  dateTime=$(TZ=$zone date +'%a %d %b %H:%M %p'),
  #location=$(echo $zone | sed -e 's/.*[/]//' -e 's/_/ /g')
  #differenceHours=$(echo $zoneDiffhours | sed -e 's/$/HRS/')
  #differenceMinutes=$zoneDifferenceMinComa


  zoneDiffhours=$(echo $zoneDifference | sed -E 's/^([[:digit:]][^ ,]*).*/\+\1/')
      if [ $(( $zoneDifferenceMin % 60 )) -eq 0 ];
      then
        #echo $dateTime $location $differenceHours
        echo "$(TZ=$zone date +'%a %d %b %H:%M %p'), $(echo $zone | sed -e 's/.*[/]//' -e 's/_/ /g') $(echo $zoneDiffhours | sed -e 's/$/HRS/' -e 's/+0HRS//g')"
      else
        #echo $dateTime $location $differenceMinutes
        echo "$(TZ=$zone date +'%a %d %b %H:%M %p'), $(echo $zone | sed -e 's/.*[/]//' -e 's/_/ /g') $zoneDifferenceMinComa"
      fi
done
