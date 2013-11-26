#!/bin/sh
if [ $1 = "-h" ]
then
    echo "usage: startSp.sh path"
fi
if [ ! -d "$1" ]; then
  echo "$1 is not a directory!"
  echo "usage: startSp.sh path"
  exit
fi
cd $1/pysaml2/example/sp
nohup python sp.py > $1/sp.out 2> $1/sp.err < /dev/null &
