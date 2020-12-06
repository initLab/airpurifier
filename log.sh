#!/bin/bash

# wait between 0 and 15 seconds to avoid race condition
sleep $(($RANDOM>>11))

cd "$(dirname "${0}")"
. ./status.sh

if [ $? -gt 0 ]
then
	exit 1
fi

AQI=$(echo "${JSON}" | jq '.aqi')
AVERAGE_AQI=$(echo "${JSON}" | jq '.average_aqi')
TEMPERATURE=$(echo "${JSON}" | jq '.temperature')
HUMIDITY=$(echo "${JSON}" | jq '.humidity')
POWER=$(echo "${JSON}" | jq '.power' | grep -c '^true$')

echo 'PUTVAL "esp_environment/labsensors-air_purifier_lecture_room/aqi"' N:"${AQI}" | socat - unix-client:"${COLLECTD_SOCKET}"
echo 'PUTVAL "esp_environment/labsensors-air_purifier_lecture_room/aqi-average"' N:"${AVERAGE_AQI}" | socat - unix-client:"${COLLECTD_SOCKET}"
echo 'PUTVAL "esp_environment/labsensors-air_purifier_lecture_room/temperature"' N:"${TEMPERATURE}" | socat - unix-client:"${COLLECTD_SOCKET}"
echo 'PUTVAL "esp_environment/labsensors-air_purifier_lecture_room/humidity"' N:"${HUMIDITY}" | socat - unix-client:"${COLLECTD_SOCKET}"
echo 'PUTVAL "esp_environment/labsensors-air_purifier_lecture_room/state"' N:"${POWER}" | socat - unix-client:"${COLLECTD_SOCKET}"
