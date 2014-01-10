#!/bin/sh
if [ $1 = "-h" ]
then
    echo "usage: startSaml2test.sh path"
fi
if [ ! -d "$1" ]; then
  echo "$1 is not a directory!"
  echo "usage: startSaml2test.sh path"
  exit
fi
cd $1/saml2testGui
nohup python server.py server_conf > $1/saml2test.out 2> $1/saml2test.err < /dev/null &
sleep 10
cat $1/saml2test.out