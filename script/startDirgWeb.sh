#!/bin/sh
if [ $1 = "-h" ]
then
    echo "usage: startDirgWeb.sh path"
fi
if [ ! -d "$1" ]; then
  echo "$1 is not a directory!"
  echo "usage: startDirgWeb.sh path"
  exit
fi
cd $1/dirg-web
nohup python dirg_web_server.py server_conf > $1/dirgweb.out 2> $1/dirgweb.err < /dev/null &
nohup python dirg_web_redirect_server.py server_conf > $1/dirgweb.out 2> $1/dirgweb.err < /dev/null &
sleep 10
cat $1/dirgweb.out
cat $1/dirgweb.err