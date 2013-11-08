#!/bin/sh
INSTALLPYOIDC="n"
INSTALLPYSAML2="n"
INSTALLBASE="n"
if [$1 = "-h"]
then
    echo "usage: setupLinux.sh install_path"
fi
if [ ! -d "$DIRECTORY" ]; then
  echo $1 is not a directory!
  echo "usage: setupLinux.sh install_path"
  exit
fi
basePath = $1
echo "Do you want to install IdPproxy (Y/n):"
read INSTALLIDPPROXY
if [ $INSTALLIDPPROXY = "Y" ]
then
    INSTALLPYOIDC="Y"
    INSTALLPYSAML2="Y"
    INSTALLBASE="Y"
fi
if [ $INSTALLPYOIDC != "Y" ]
then
    echo "Do you want to install pyoidc (Y/n):"
    read INSTALLPYOIDC
    if [ $INSTALLPYOIDC = "Y" ]
    then
        INSTALLBASE="Y"
    fi
fi
if [ $INSTALLPYSAML2 != "Y" ]
then
    echo "Do you want to install pysaml2 (Y/n):"
    read INSTALLPYSAML2
    if [ $INSTALLPYSAML2 = "Y" ]
    then
        INSTALLBASE="Y"
    fi
fi
if [ $INSTALLBASE = "Y" ]
then
    sudo apt-get install python-setuptools
    sudo apt-get install python-dev
    sudo easy_install pip
    sudo apt-get install swig
    sudo easy_install mako
    ############################################################
    echo "______________________________________________________"
    echo "Installing pyjwkest..."
    pyjwkestPath="$basePath/pyjwkest"
    sudo rm -fr $pyjwkestPath
    sudo git clone https://github.com/rohe/pyjwkest $pyjwkestPath
    cd $pyjwkestPath
    echo "Running setup.py (this can take a while)."
    sudo python setup.py install > /dev/null 2> /dev/null
    echo "pyjwkest installed"
fi
############################################################
echo "______________________________________________________"
if [ $INSTALLPYOIDC = "Y" ]
then
    echo "Installing pyoidc..."
    pyoidcPath="$basePath/pyoidc"
    sudo rm -fr $pyoidcPath
    sudo git clone https://github.com/rohe/pyoidc $pyoidcPath
    cd $pyoidcPath
    echo "Running setup.py (this can take a while)."
    sudo python setup.py install > /dev/null 2> /dev/null
    sudo apt-get install python-ldap
    sudo pip install python-ldap
    echo "pyoidc installed"
else
    echo "Skipping pyoidc."
fi
############################################################
echo "______________________________________________________"
if [ $INSTALLPYSAML2 = "Y" ]
then
    echo "Installing pysaml2..."
    pysaml2Path="$basePath/pysaml2"
    sudo rm -fr $pysaml2Path
    sudo git clone https://github.com/rohe/pysaml2 $pysaml2Path
    cd $pysaml2Path
    echo "Running setup.py (this can take a while)."
    sudo python setup.py install > /dev/null 2> /dev/null
    sudo easy_install repoze.who
    sudo easy_install ElementTree
    sudo apt-get install python-dateutil libxmlsec1 xmlsec1 libxmlsec1-openssl libxmlsec1-dev
    sudo apt-get install libxml2
    sudo apt-get install libtool
    echo "pysaml2 installed"
else
    echo "Skipping pysaml2."
fi
############################################################
echo "______________________________________________________"
if [ $INSTALLIDPPROXY = "Y" ]
then
    echo "Installing IdPproxy..."
    oauthPath="$basePath/python-oauth2"
    sudo rm -fr $oauthPath
    sudo git clone https://github.com/simplegeo/python-oauth2 $oauthPath
    cd $oauthPath
    echo "Running setup.py (this can take a while)."
    sudo python setup.py install > /dev/null 2> /dev/null
    IdPproxyPath="$basePath/IdPproxy"
    sudo rm -fr $IdPproxyPath
    sudo git clone https://github.com/rohe/IdPproxy $IdPproxyPath
    cd $IdPproxyPath
    echo "Running setup.py (this can take a while)."
    sudo python setup.py install > /dev/null 2> /dev/null
    echo "IdPproxy installed"
else
    echo "Skipping IdPproxy."
fi
############################################################
if [ $INSTALLPYSAML2 = "Y" ]
then
    echo "Do you want to configure an test IdP and SP? (Y/n):"
    read CONFIGUREIDPSP
    if [ CONFIGUREIDPSP = "Y" ]
    then
        idpConfFile = "$pysaml2Path/example/idp/yaisIdpConf.py"
        spConfFile = "$pysaml2Path/example/idp/yaisSpConf.py"
        spMetadataFile = "$pysaml2Path/example/sp/yaisSp.xml"
        idpMetadataFile = "$pysaml2Path/example/idp/yaisIdp.xml"
        setupIdp.py $pysaml2Path /usr/yais/templates/idp/create_testserver_idp_conf.json -M $spMetadataFile
        setupSp.py $pysaml2Path /usr/yais/templates/sp/create_testclient_sp_conf.json -M idpMetadataFile
        make_metadata.py $idpConfFile > idpMetadataFile
        make_metadata.py $spConfFile > spMetadataFile
        echo "Do you want to start test IdP and SP? (Y/n):"
        read STARTCONFIGUREIDPSP
        if [ STARTCONFIGUREIDPSP = "Y" ]
            `$pysaml2Path/example/idp/idp.py $idpConfFile`
            `$pysaml2Path/example/sp/sp.py $spConfFile`
        fi
    fi
fi
