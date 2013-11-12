#!/bin/sh
if [ $1 = "-h" ]
then
    echo "usage: restartSp.sh path"
fi
if [ ! -d "$1" ]; then
  echo "$1 is not a directory!"
  echo "usage: restartSp.sh path"
  exit
fi
cd $1/pysaml2/example/sp
nohup python sp.py sp_conf &