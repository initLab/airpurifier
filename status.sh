#!/bin/bash

. ./config

JSON="$(~/miio/bin/miiocli -o json airpurifiermiot --ip "${IP_ADDR}" --token "${XIAOMI_TOKEN}" status)"
IS_ERROR=$(echo "${JSON}" | grep -ci '^error\|"code"')

echo "${JSON}"

if [ $IS_ERROR -gt 0 ]
then
	echo 'ERROR'
	exit 1
fi
