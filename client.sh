#!/bin/bash

rand_sleep1=$((0+RANDOM%6))	
sleep $rand_sleep1
#client=$1
#statsfile="client"$client".log"
#[ -e $statsfile ] && rm $statsfile
#touch $statsfile

# Check for nill INTERVAL secs, default = 10
#INTERVAL=$2
#clear
#if [ "$INTERVAL" -lt "$((1))" ]; then
#        INTERVAL=10
#fi

#Sub-shell process to send the stats back to the controller every INTERVAL secs
#(
#intervalStart=$(date +%s)
#
#while [ true ]
#do
#
#        if [ "$(date +%s)" -ge "$((intervalStart+INTERVAL))" ]; then
#                #echo "New interval"
#                intervalStart=$(date +%s)
#        fi
#
#done
#) &

#Main process
while [ true ]
do

	rand=$((1+RANDOM%20))
	filename="img"$rand".jpg"

	# Submit start time
	curl --interface en0 -H "Content-Type: application/json" -X POST -d '{"start_time":"'$(date +%s)'"}' \
	http://10.0.0.50:8001/controller/collector/

        ART=$(curl --interface en0 -o /dev/null -s -w %{time_total} -X POST -F "file=@$filename;type=image/jpeg" 10.0.0.50:8000/tesseract/imageUpload/$filename) 

        #curl --interface en0 -o /dev/null -s -w %{time_total} -X POST -F "file=@$filename;type=image/jpeg" 10.0.0.50:8000/tesseract/imageUpload/$filename
	#>> $statsfile
        #echo $'' >> $statsfile

	# Submit response time
	curl --interface en0 -H "Content-Type: application/json" -X POST -d '{"rt":"'$ART'"}' \
	http://10.0.0.50:8001/controller/collector/
	
	# Submit end time
	curl --interface en0 -H "Content-Type: application/json" -X POST -d '{"end_time":"'$(date +%s)'"}' \
	http://10.0.0.50:8001/controller/collector/

	rand_sleep=$((10+RANDOM%15))
	sleep $rand_sleep
done
