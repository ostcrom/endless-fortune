#!/usr/bin/bash

if [ -z "$ENV_SLEEP" ]
then
	echo "ENV_SLEEP not set, defaulting to 1";
	ENV_SLEEP=1
else
	echo "ENV_SLEEP set to $ENV_SLEEP"
fi


while true; do
	echo `date` `fortune`;
	sleep $ENV_SLEEP;
done;
