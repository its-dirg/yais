#!/bin/sh
if [ $1 = "-h" ]
then
    echo "usage: restartDirgWeb.sh path"
fi
if [ ! -d "$1" ]; then
  echo "$1 is not a directory!"
  echo "usage: restartDirgWeb.sh path"
  exit
fi
stopDirgWeb.sh
sleep 10
startDirgWeb.sh /usr/share/dig/projects