#!/bin/sh
if [ $1 = "-h" ]
then
    echo "usage: restartIdp.sh path"
fi
if [ ! -d "$1" ]; then
  echo "$1 is not a directory!"
  echo "usage: restartIdp.sh path"
  exit
fi
stopIdp.sh
cd $1/pysaml2/example/idp2
nohup python idp.py idp_conf > $1/idp.out 2> $1/idp.err < /dev/null &