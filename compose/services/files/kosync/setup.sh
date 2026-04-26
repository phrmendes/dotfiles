#!/usr/bin/env sh

set -e

RESPONSE=$(curl -s -o /dev/null -w '%{http_code}' -X POST http://kosync:17200/users/create \
	-d "username=${KOSYNC_USER}&password=${KOSYNC_PASSWORD}")

if [ "$RESPONSE" = '409' ]; then
	echo 'INFO: User already exists, skipping'
	exit 0
fi

if [ "$RESPONSE" != '201' ]; then
	echo "ERROR: Unexpected response: ${RESPONSE}"
	exit 1
fi

echo 'INFO: User created successfully'
