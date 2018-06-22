#!/bin/bash

if [ ! -d "$LOCAL_PATH" ]; then
  mkdir $LOCAL_PATH
fi

if find "$LOCAL_PATH" -mindepth 1 -print -quit 2>/dev/null | grep -q .; then
    echo "$LOCAL_PATH is not empty. Stopping."
	exit
else
    echo "$LOCAL_PATH is empty"
fi

echo -n "Mounting $REMOTE_PATH to $LOCAL_PATH ... "

mount -t cifs $REMOTE_PATH $LOCAL_PATH -o user=$REMOTE_USER,password=$REMOTE_PASSWORD,vers=3.02

echo "Done!"

cd $LOCAL_PATH

exec /bin/bash