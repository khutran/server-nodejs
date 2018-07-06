#!/bin/bash

name="$(cat /home/name.txt)"
path="/var/www/web"
# Make sure we're not confused by old, incompletely-shutdown httpd
# context after restarting the container.  httpd won't start correctly
# if it thinks it is already running.

rm -rf /run/nginx*
rm -rf /root/.forever/pids/*
rm -rf /root/.forever/sock/*

if [ ! -d "$path/$name" ]; then
  if [ -d "$path/source_code" ]; then
    mkdir $path/$name
    mv $path/source_code $path/$name/workspace
  fi
else 
  echo "$path/$name"
fi

cd $path/$name/workspace

yarn install
yarn build 

forever start "/var/www/config/ecosystem/"$name".json"

exec nginx