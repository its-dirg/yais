#!/bin/sh
if [ $1 = "-h" ]; then
    echo "usage: yaisLinux.sh install_path [group]"
    exit
fi
if [ ! -d "$1" ]; then
  echo $1 is not a directory!
  echo "usage: yaisLinux.sh install_path [group]"
  exit
fi
basePath=$1

#Setup language (may have to run each time the software starts)
unset LC_CTYPE LANG
export LC_ALL="en_US.UTF-8"

sudo apt-get upgrade;
sudo apt-get update

verify=`dpkg --get-selections | grep libreadline-dev | wc -l`
if [ $verify = 0 ]; then
    ############################################################
    echo "______________________________________________________"
    echo "Installing libreadline-dev..."
    sudo apt-get install libreadline-dev
    echo "libreadline-dev installed"
else
    echo "libreadline-dev already installed"
fi

verify=`dpkg --get-selections | grep python-software-properties | wc -l`
if [ $verify = 0 ]; then
    ############################################################
    echo "______________________________________________________"
    echo "Installing python-software-properties..."
    sudo apt-get install python-software-properties
    echo "python-software-properties installed"
else
    echo "python-software-properties already installed"
fi

verify=`dpkg --get-selections | grep git | wc -l`
if [ $verify = 0 ]; then
    ############################################################
    echo "______________________________________________________"
    echo "Installing git..."
    sudo apt-get install git
    echo "git installed"
else
    echo "git already installed"
fi

verify=`dpkg --get-selections | grep build-essential | wc -l`
if [ $verify = 0 ]; then
    ############################################################
    echo "______________________________________________________"
    echo "Installing build-essential..."
    sudo apt-get install build-essential
    echo "build-essential installed"
else
    echo "build-essential already installed"
fi

verify=`dpkg --get-selections | grep python | wc -l`
if [ $verify = 0 ]; then
    ############################################################
    echo "______________________________________________________"
    echo "Installing python..."
    sudo apt-get install python
    echo "python installed"
else
    echo "python already installed"
fi

verify=`dpkg --get-selections | grep libssl-dev | wc -l`
if [ $verify = 0 ]; then
    ############################################################
    echo "______________________________________________________"
    echo "Installing libssl-dev..."
    sudo apt-get install libssl-dev
    echo "libssl-dev installed"
else
    echo "libssl-dev already installed"
fi

verify=`dpkg --get-selections | grep python-setuptools | wc -l`
if [ $verify = 0 ]; then
    ############################################################
    echo "______________________________________________________"
    echo "Installing setuptools..."
    sudo apt-get install python-setuptools
    echo "setuptools installed"
else
    echo "setuptools already installed"
fi

verify=`pip -V | grep pip | grep python | wc -l`
if [ $verify != 1 ]; then
    ############################################################
    echo "______________________________________________________"
    echo "Installing pip..."
    sudo easy_install pip
    echo "pip installed"
else
    echo "pip already installed"
fi

############################################################
echo "______________________________________________________"
echo "Installing pcre..."
cd $basePath
verify=`dpkg --get-selections | grep libpcre3 | wc -l`
if [ $verify = 0 ]; then
    sudo apt-get install libpcre3
fi
verify=`dpkg --get-selections | grep libpcre3-dev | wc -l`
if [ $verify = 0 ]; then
    sudo apt-get install libpcre3-dev
fi
echo "pcre installed"


verify=`dpkg --get-selections | grep python-dev | wc -l`
if [ $verify = 0 ]; then
    ############################################################
    echo "______________________________________________________"
    cd $basePath
    echo "Installing python-dev..."
    sudo apt-get install python-dev
    echo "python-dev installed"
else
    echo "python-dev already installed"
fi

verify=`dpkg --get-selections | grep swig | wc -l`
if [ $verify = 0 ]; then
    ############################################################
    echo "______________________________________________________"
    cd $basePath
    echo "Installing swig..."
    sudo apt-get install swig
    echo "swig installed"
else
    echo "swig already installed"
fi

verify=`dpkg --get-selections | grep python-py | wc -l`
if [ $verify = 0 ]; then
    ############################################################
    echo "______________________________________________________"
    cd $basePath
    echo "Installing python-py..."
    sudo apt-get install python-py
    sudo pip install pytest
    echo "python-py installed"
else
    echo "python-py already installed"
fi

cd "/"
verify=`pip freeze | grep oic== | wc -l`
if [ $verify = 0 ]; then
    cd $basePath
    echo "Installing pyoidc..."
    pyoidcPath="$basePath/pyoidc"
    sudo rm -fr $pyoidcPath
    git clone https://github.com/rohe/pyoidc $pyoidcPath
    cd $pyoidcPath
    echo "Running setup.py (this can take a while)."
    sudo python setup.py install > /dev/null 2> /dev/null
    sudo apt-get install python-ldap
    sudo pip install python-ldap
    echo "pyoidc installed"
else
    echo "pyoidc already installed"
fi

verify=`pip freeze | grep oictest== | wc -l`
if [ $verify = 0 ]; then
    cd $basePath
    echo "Installing oictest..."
    oictestPath="$basePath/oictest"
    sudo rm -fr $oictestPath
    sudo git clone https://github.com/rohe/oictest $oictestPath
    cd $oictestPath
    echo "Running setup.py (this can take a while)."
    sudo python setup.py install > /dev/null 2> /dev/null
    echo "oictest installed"
else
    echo "oictest already installed"
fi


cd $basePath
verify=`ls | grep fedlab | wc -l`
if [ $verify = 0 ]; then
    cd $basePath
    echo "Installing Node.js..."
    cd $basePath
    wget http://nodejs.org/dist/v0.10.2/node-v0.10.2-linux-arm-pi.tar.gz
    tar -xvzf node-v0.10.2-linux-arm-pi.tar.gz
    node-v0.10.2-linux-arm-pi/bin/node --version

    echo "Installing fedlab..."
    fedlabPath="$basePath/fedlab"
    sudo rm -fr $fedlabPath
    sudo git clone https://github.com/rohe/fedlab $fedlabPath

    cd $fedlabPath/frontend

    export NODE_JS_HOME=/home/pi/node-v0.10.2-linux-arm-pi
    export PATH=$PATH:$NODE_JS_HOME/bin

    sudo $basePath/node-v0.10.2-linux-arm-pi/bin/npm install

    sudo cp $fedlabPath/frontend/etc/config.template.js $fedlabPath/frontend/etc/config.js

    echo "fedlab installed"
else
    echo "fedlab already installed"
fi

verify=`dpkg --get-selections | grep php5-cli | wc -l`
if [ $verify = 0 ]; then
    ############################################################
    echo "______________________________________________________"
    echo "Installing php5-cli ..."
    sudo apt-get install php5-cli
    echo "php5-cli  installed"
else
    echo "php5-cli  already installed"
fi

verify=`dpkg --get-selections | grep php5-mcrypt | wc -l`
if [ $verify = 0 ]; then
    ############################################################
    echo "______________________________________________________"
    echo "Installing php5-mcrypt ..."
    sudo apt-get install php5-mcrypt
    echo "php5-mcrypt  installed"
else
    echo "php5-mcrypt  already installed"
fi

verify=`dpkg --get-selections | grep php5-gmp | wc -l`
if [ $verify = 0 ]; then
    ############################################################
    echo "______________________________________________________"
    echo "Installing php5-gmp ..."
    sudo apt-get install php5-gmp
    echo "php5-gmp  installed"
else
    echo "php5-gmp  already installed"
fi

verify=`dpkg --get-selections | grep php5-curl | wc -l`
if [ $verify = 0 ]; then
    ############################################################
    echo "______________________________________________________"
    echo "Installing php5-curl ..."
    sudo apt-get install php5-curl
    echo "php5-curl  installed"
else
    echo "php5-curl  already installed"
fi
