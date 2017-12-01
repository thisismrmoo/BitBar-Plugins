#!/bin/bash

#Establishes current system Location. Prints without "_" and Country. e.g. Melbourne
currentZone=$(sudo systemsetup -gettimezone | sed -e 's/Time Zone://g' -e 's/.*[/]//' -e 's/_/ /g')
#Establishes current system Time and Date. e.g. Fri 01 Dec 12:20 AM,
currentDate=$(date +'%a %d %b %H:%M %p'),

#List of TimeZones to display in BitBar Dropdown.
timeZones="America/Los_Angeles America/Vancouver 	America/Winnipeg America/New_York Europe/London Europe/Paris Asia/Kolkata Asia/Bangkok Asia/Kuala_Lumpur Australia/Brisbane Australia/Melbourne Pacific/Auckland"

#Displays Curent Date, Time, and Locataion in Menubar. e.g. Fri 01 Dec 12:20 AM, Melbourne
echo $currentDate $currentZone

#Creates Dropdown menu in BitBar.
echo '---'

#Attributes for Dropdown Menu per each item in "timeZones".
for zone in $timeZones;
do
  #Establishes time of current location to compare to all timeZones, giving a time difference reading.
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

  #Establishes time of all timeZones to compare to current location time, giving a time difference reading.
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

  #Establishes time difference of current location and "timeZones" in hours.
  zoneDifference=$(expr $zoneTotalHours - $currentTotalHours)
  #Establishes time difference of current location and "timeZones" in minutes.
  zoneDifferenceMin=$(expr $zoneTotalmins - $currentTotalmins)
  #Establishes time difference of current location and "timeZones" in minutes with coma for display. e.g -3:30
  zoneDifferenceMinComa=$(echo $zoneDifferenceMin | sed -e 's/.\{2\}$/:&/g')

  #Establishes "timeZones" Time and Date. e.g. Thu 30 Nov 17:20 PM,
  dateTime=$(TZ=$zone date +'%a %d %b %H:%M %p'),

  #Establishes whether to display Time Difference in hours or minutes.
  zoneDiffhours=$(echo $zoneDifference | sed -E 's/^([[:digit:]][^ ,]*).*/\+\1/')
      if [ $(( $zoneDifferenceMin % 60 )) -eq 0 ];
      then
        #Displays Date, Time, Locataion and Time Difference in hours in Dropdown. e.g. Thu 30 Nov 17:20 PM, Los Angeles -19HRS
        echo "$(TZ=$zone date +'%a %d %b %H:%M %p'), $(echo $zone | sed -e 's/.*[/]//' -e 's/_/ /g') $(echo $zoneDiffhours | sed -e 's/$/HRS/' -e 's/+0HRS//g')"
      else
        #Displays Date, Time, Locataion and Time Difference in minutes in Dropdown. e.g. Fre 01 Dec 07:20 AM, Kolkata -3:30
        echo "$(TZ=$zone date +'%a %d %b %H:%M %p'), $(echo $zone | sed -e 's/.*[/]//' -e 's/_/ /g') $zoneDifferenceMinComa"
      fi
done
