#!/usr/bin/env bash

echo "Add the following to /etc/hosts"
echo "127.0.0.1       gallo.cosi.cwru.edu"
ssh -N -n -L 9021:127.0.0.1:9021 -L 4567:127.0.0.1:4567 $VPS_LOGIN_STR
