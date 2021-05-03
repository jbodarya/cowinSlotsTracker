#!/bin/bash

# change below if you want to increse Interval
SLEEP=1

onDate=`date --date="+1 day" +%d-%m-%Y`
URI="https://cdn-api.co-vin.in/api/v2"
echo "------------------ State List ---------------"

curl -X GET "$URI/admin/location/states" -H  "accept: application/json" -H  "Accept-Language: hi_IN" | python -mjson.tool

echo "---------------------------------------------"
echo -n "Please Enter state number : " 
read stateNumber

if [ $stateNumber -lt 0 ] || [ $stateNumber -gt 37 ];then
	echo "Invalid state"
	exit -1
fi
curl -X GET "$URI/admin/location/districts/${stateNumber}" -H  "accept: application/json" -H  "Accept-Language: hi_IN" | python -mjson.tool

echo "---------------------------------------------"
echo -n "Please Enter district number : " 
read district
echo "---------------------------------------------"
echo -n "Please Enter Age [18 or 45] : [default is 18] : " 
read minAge

if [ $minAge -ne 45 ];then
	minAge=18
fi
echo "Showing results for STATE : $stateNumber , district = $district , Age = $minAge :" 

while true
do
	avail=`curl -X GET "$URI/appointment/sessions/public/findByDistrict?district_id=${district}&date=${onDate}" -H  "accept: application/json" -H  "Accept-Language: hi_IN"`

	echo $avail | python -mjson.tool
	slot=`echo $avail | python -mjson.tool | grep available_capacity | grep -v "available_capacity=0" | wc -l`
	age=`echo $avail | python -mjson.tool | grep '"min_age_limit": $minAge' | wc -l`
	
	if [ $slot -gt 0 ] && [ $age -gt 0 ];then
		echo "SLOTS available.........."
	fi

	sleep $SLEEP

done
