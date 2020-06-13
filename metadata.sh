#!/bin/bash

# sleep until instance is ready
until [[ -f /var/lib/cloud/instance/boot-finished ]]; do
  sleep 1
done

# install nginx
apt-get update
apt-get -y install nginx

# make sure nginx is started
service nginx start

# get meta-data top level items
a=($(curl http://169.254.169.254/latest/meta-data/))
echo "{" > metadata.json
# loop through all items getting their values and storing them in metadata.json
for i in ${a[@]}
do
  val=$(curl -s  http://169.254.169.254/latest/meta-data/$i)
  echo "\"$i\"" ":"  "\"$val\"," >> metadata.json
done
echo "}" >> metadata.json

# remove new line characters where multiples are returned and move the file to html folder
# so that the metadata.json can be accessed via web page for easy reference
sed ':a;N;$!ba;s/\n/ /g' metadata.json | sed 's/, }$/}/'  >  /var/www/html/metadata.json