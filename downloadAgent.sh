#!/bin/sh

DOWNLOAD_PATH=https://download-files.appdynamics.com/

FILE_PATH=$(curl https://download.appdynamics.com/download/downloadfilelatest/ | jq -r '.[].s3_path' | grep sun)

DOWNLOAD_PATH=$DOWNLOAD_PATH$FILE_PATH

echo "Downloading agent from: " $DOWNLOAD_PATH

curl -L $DOWNLOAD_PATH -o ./JavaAgent.zip
