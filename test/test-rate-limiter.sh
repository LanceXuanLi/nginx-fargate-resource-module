#!/bin/bash

URL="http://sapia-2110721541.ap-southeast-2.elb.amazonaws.com"

for i in {1..320}
do
  echo "Request #$i"
  curl -s $URL
  echo
done