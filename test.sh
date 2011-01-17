#!/bin/bash

set -eux

port="${0:-9090}"

echo "Ping: "

curl -D- http://localhost:${port}/ping

echo
echo "Edit: "

curl -D- http://localhost:${port}/edit \
  -d 'token=narf' \
  -d 'content=This is the test text.

Please enjoy.'


