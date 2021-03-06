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
stopSp.sh
cd $1/pysaml2/example/sp
nohup python sp.py > $1/sp.out 2> $1/sp.err < /dev/null &