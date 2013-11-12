 #!/bin/sh
 if [ $1 = "-h" ]
then
    echo "usage: update.sh path"
fi
if [ ! -d "$1" ]; then
  echo "$1 is not a directory!"
  echo "usage: setupLinux.sh path"
  exit
fi
if [ -d "$1/pyjwkest" ]; then
    cd "$1/pyjwkest"
    git pull origin master
    sudo python setup.py install
fi
if [ -d "$1/pyoidc" ]; then
    cd "$1/pyoidc"
    git pull origin master
    sudo python setup.py install
fi
if [ -d "$1/IdPproxy" ]; then
    cd "$1/IdPproxy"
    git pull origin master
    sudo python setup.py install
fi
if [ -d "$1/pysaml2" ]; then
    cd "$1/pysaml2"
    git pull origin master
    sudo python setup.py install
fi