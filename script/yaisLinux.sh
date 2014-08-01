#!/bin/sh
#gcc must be installed
#brew must be installed for mac
#yum must be installed för RedHat
#apt-get must be installed för debian

INSTALLPYOIDC="n"
INSTALLPYSAML2="n"
INSTALLSAML2TEST="n"
INSTALLDIRGWEB="n"
INSTALLOICTEST="n"
INSTALLBASE="n"
INSTALLOICTESTGUI="n"

if [ $1 = "-h" ]
then
    echo "usage: yaisLinux.sh install_path [os(mac | debian)]"
fi
if [ ! -d "$1" ]; then
  echo $1 is not a directory!
  echo "usage: yaisLinux.sh install_path [group]"
  exit
fi

os="debian"

#if [ $2 = "mac" ] || [ $2 = "debian" ] ; then
#    os=$2
#fi

basePath=$1
echo "Do you want to install IdProxy (Y/n):"
read INSTALLIDPROXY
if [ $INSTALLIDPROXY = "Y" ]
then
    INSTALLPYOIDC="Y"
    INSTALLPYSAML2="Y"
    INSTALLBASE="Y"
fi
echo "Do you want to install Social2Saml (Y/n):"
read SOCIAL2SAML
if [ $SOCIAL2SAML = "Y" ]
then
    INSTALLPYOIDC="Y"
    INSTALLPYSAML2="Y"
    INSTALLBASE="Y"
fi
echo "Do you want to install verify_entcat (Y/n):"
read VERIFYENTCAT
if [ $VERIFYENTCAT = "Y" ]
then
    INSTALLPYSAML2="Y"
    INSTALLBASE="Y"
fi
echo "Do you want to install dirg-web (Y/n):"
read INSTALLDIRGWEB
if [ $INSTALLDIRGWEB = "Y" ]
then
    INSTALLPYSAML2="Y"
    INSTALLBASE="Y"
fi
echo "Do you want to install saml2test (Y/n):"
read INSTALLSAML2TEST
if [ $INSTALLSAML2TEST = "Y" ]
then
    INSTALLPYSAML2="Y"
    INSTALLBASE="Y"
fi
if [ $INSTALLPYOIDC = "n" ]
then
    echo "Do you want to install pyoidc (Y/n):"
    read INSTALLPYOIDC
    if [ $INSTALLPYOIDC = "Y" ]
    then
        INSTALLPYSAML2="Y"
        INSTALLBASE="Y"
    fi
fi
echo $INSTALLPYSAML2
if [ $INSTALLPYSAML2 = "n" ]
then
    echo "Do you want to install pysaml2 (Y/n):"
    read INSTALLPYSAML2
    if [ $INSTALLPYSAML2 = "Y" ]
    then
        INSTALLBASE="Y"
    fi
fi

echo $INSTALLOICTESTGUI
if [ $INSTALLOICTESTGUI = "n" ]
then
    echo "Do you want to install oictestGui (Y/n):"
    read INSTALLOICTESTGUI
    if [ $INSTALLOICTESTGUI = "Y" ]
    then
        INSTALLPYOIDC="Y"
        INSTALLOICTEST="Y"
        INSTALLBASE="Y"
    fi
fi

echo $INSTALLOICTEST
if [ $INSTALLOICTEST = "n" ]
then
    echo "Do you want to install oictest (Y/n):"
    read INSTALLOICTEST
    if [ $INSTALLOICTEST = "Y" ]
    then
        INSTALLPYOIDC="Y"
        INSTALLBASE="Y"
    fi
fi

if [ $INSTALLBASE = "Y" ]
then
    if [ $os = "debian" ]
    then
        sudo apt-get update
        sudo apt-get install python-setuptools
        sudo apt-get install python-dev
    fi
    wget https://bitbucket.org/pypa/setuptools/raw/bootstrap/ez_setup.py -O - | sudo python
    sudo easy_install -U setuptools
    sudo easy_install pip
    sudo easy_install mako
    sudo pip install pycrypto
    sudo pip install cherrypy==3.2.4
    if [ $os = "debian" ]
    then
        sudo apt-get install python-ldap
    else
        sudo pip install python-ldap
    fi
    sudo pip install python-ldap
    ############################################################
    echo "______________________________________________________"
    echo "Installing pyjwkest..."
    pyjwkestPath="$basePath/pyjwkest"
    sudo rm -fr $pyjwkestPath
    git clone https://github.com/rohe/pyjwkest $pyjwkestPath
    cd $pyjwkestPath
    echo "Running setup.py (this can take a while)."
    sudo python setup.py install > /dev/null 2> /dev/null
    echo "pyjwkest installed"
    ############################################################
    echo "______________________________________________________"
    echo "Installing dirg-util..."
    sudo pip install validate_email
    sudo pip install pyDNS
    dirgutilPath="$basePath/dirg-util"
    sudo rm -fr $dirgutilPath
    git clone https://github.com/its-dirg/dirg-util $dirgutilPath
    cd $dirgutilPath
    sudo python setup.py install > /dev/null 2> /dev/null
    echo "dirg-util installed"
    sudo apt-get install libffi-dev
    #apt-get install python-openssl
    sudo pip install pyOpenSSL==0.13.1
    sudo pip install argparse
    sudo pip install importlib
fi
############################################################
echo "______________________________________________________"
if [ $INSTALLPYOIDC = "Y" ]
then
    echo "Installing pyoidc..."
    if [ $os = "debian" ]
    then
        sudo apt-get install swig
        sudo apt-get install python-m2crypto
        installM2CryptoLinux.sh
    fi
    if [ $os = "mac" ]
    then
        brew install swig
        sudo easy_install M2Crypto
    fi

    sudo pip install pyOpenSSL

    pyoidcPath="$basePath/pyoidc"
    sudo rm -fr $pyoidcPath
    git clone https://github.com/rohe/pyoidc $pyoidcPath
    cd $pyoidcPath
    echo "Running setup.py (this can take a while)."
    sudo python setup.py install > /dev/null 2> /dev/null
    echo "pyoidc installed"
else
    echo "Skipping pyoidc."
fi
############################################################
echo "______________________________________________________"
if [ $INSTALLPYSAML2 = "Y" ]
then
    echo "Installing pysaml2"
    if [ $os = "debian" ]
    then
        sudo apt-get remove --auto-remove python-crypto
        sudo pip uninstall pycrypto
        cd $basePath
        wget https://ftp.dlitz.net/pub/dlitz/crypto/pycrypto/pycrypto-2.6.1.tar.gz
        tar -zxvf pycrypto-2.6.1.tar.gz
        cd "$basePath/pycrypto-2.6.1"
        sudo python setup.py install > /dev/null 2> /dev/null
        cd ..
        rm pycrypto-2.6.1.tar.gz
    fi
    pysaml2Path="$basePath/pysaml2"
    echo " into the $path $pysaml2Path"
    sudo rm -fr $pysaml2Path
    git clone https://github.com/rohe/pysaml2 $pysaml2Path
    #git clone https://github.com/rohe/pysaml2 $pysaml2Path
    cd $pysaml2Path
    echo "Running setup.py (this can take a while)."
    sudo python setup.py install > /dev/null 2> /dev/null
    sudo easy_install repoze.who
    sudo easy_install ElementTree
    if [ $os = "debian" ]
    then
        sudo apt-get install python-dateutil libxmlsec1 xmlsec1 libxmlsec1-openssl libxmlsec1-dev
        sudo apt-get install libxml2
        sudo apt-get install libtool
    fi
    if [ $os = "mac" ]
    then
        brew install libxmlsec1
    fi
    echo "pysaml2 installed"
else
    echo "Skipping pysaml2."
fi
############################################################
echo "______________________________________________________"
if [ $INSTALLSAML2TEST = "Y" ]
then
    # Install saml2test
    echo "Installing saml2test"
    saml2testPath="$basePath/saml2test"
    echo " into the $path $saml2testPath"
    sudo rm -fr $saml2testPath
    git clone https://github.com/rohe/saml2test $saml2testPath
    cd $saml2testPath
    echo "Running setup.py (this can take a while)."
    sudo python setup.py install > /dev/null 2> /dev/null


    # Installing saml2testGui
    saml2testGuiPath="$basePath/saml2testGui"
    echo " into the $path $saml2testGuiPath"
    sudo rm -fr $saml2testGuiPath
    git clone https://github.com/its-dirg/saml2testGui $saml2testGuiPath
    cd $saml2testGuiPath
    echo "Running setup.py (this can take a while)."
    sudo python setup.py install > /dev/null 2> /dev/null

    echo "saml2test installed"
else
    echo "Skipping saml2test."
fi
############################################################
echo "______________________________________________________"
if [ $SOCIAL2SAML = "Y" ]
then
    echo "Installing Social2SAML..."
    oauthPath="$basePath/python-oauth2"
    sudo rm -fr $oauthPath
    git clone https://github.com/simplegeo/python-oauth2 $oauthPath
    cd $oauthPath
    echo "Running setup.py (this can take a while)."
    sudo python setup.py install > /dev/null 2> /dev/null
    IdPproxyPath="$basePath/IdPproxy"
    sudo rm -fr $IdPproxyPath
    git clone https://github.com/rohe/IdPproxy $IdPproxyPath
    cd $IdPproxyPath
    echo "Running setup.py (this can take a while)."
    sudo python setup.py install > /dev/null 2> /dev/null
    echo "Social2SAML installed"
else
    echo "Skipping Social2SAML."
fi
############################################################
echo "______________________________________________________"
if [ $INSTALLDIRGWEB = "Y" ]
then
    echo "Installing dirg-web..."
    sudo easy_install Beaker
    dirgwebPath="$basePath/dirg-web"
    sudo rm -fr $dirgwebPath
    git clone https://github.com/its-dirg/dirg-web $dirgwebPath
    cd $dirgwebPath
    sudo python setup.py install > /dev/null 2> /dev/null
    echo "dirg-web installed"
else
    echo "Skipping dirg-web."
fi
############################################################
echo "______________________________________________________"
if [ $VERIFYENTCAT = "Y" ]
then
    echo "Installing verify_entcat..."
    dirgve="$basePath/verify_entcat"
    sudo rm -fr $dirgve
    git clone https://github.com/its-dirg/verify_entcat $dirgve
    cd $dirgve
    sudo python setup.py install > /dev/null 2> /dev/null
    echo "verify_entcat installed"
else
    echo "Skipping verify_entcat."
fi
############################################################
echo "______________________________________________________"
if [ $INSTALLIDPROXY = "Y" ]
then
    echo "Installing IdProxy..."
    pyYubitoolPath="$basePath/pyYubitool"
    sudo rm -fr $pyYubitoolPath
    git clone https://github.com/HaToHo/pyYubitool $pyYubitoolPath
    cd $pyYubitoolPath
    sudo python setup.py install > /dev/null 2> /dev/null

    IdProxyPath="$basePath/IdProxy"
    sudo rm -fr $IdProxyPath
    git clone https://github.com/its-dirg/IdProxy $IdProxyPath
    cd $IdProxyPath
    sudo python setup.py install > /dev/null 2> /dev/null
    echo "IdProxy installed"
else
    echo "Skipping IdProxy."
fi
############################################################
echo "______________________________________________________"
if [ $INSTALLOICTEST = "Y" ]
then
    echo "Installing oictest..."
    oictestPath="$basePath/oictest"
    sudo rm -fr $oictestPath
    git clone https://github.com/rohe/oictest $oictestPath
    cd $oictestPath
    sudo python setup.py install > /dev/null 2> /dev/null
    echo "oictest installed"
else
    echo "Skipping oictest."
fi
############################################################
echo "______________________________________________________"
if [ $INSTALLOICTEST = "Y" ]
then
    echo "Installing oictestGui..."
    oictestGuiPath="$basePath/oictestGui"
    sudo rm -fr $oictestGuiPath
    git clone https://github.com/its-dirg/oictestGui $oictestGuiPath
    cd $oictestGuiPath
    sudo python setup.py install > /dev/null 2> /dev/null
    echo "oictestGui installed"
else
    echo "Skipping oictestGui."
fi
############################################################
if [ $INSTALLPYSAML2 = "Y" ]
then
    configureSaml.sh $basePath
fi
