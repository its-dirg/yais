#!/bin/sh
#apt-get must be installed on debian
#gcc, wget and git must be installed (will be installed on debian)
#brew must be installed on mac (will be installed on mac together with wget)

INSTALLPYOIDC="n"
INSTALLPYSAML2="n"
INSTALLSAML2TEST="n"
INSTALLDIRGWEB="n"
INSTALLOICTEST="n"
INSTALLBASE="n"
INSTALLOICTESTGUI="n"

USAGE_STRING="usage: yaisLinux.sh install_path"

if [ "$1" = "-h" ]; then
    echo ${USAGE_STRING}
    exit
fi

if [ ! -d "$1" ]; then
  echo "${1} is not a directory!"
  echo ${USAGE_STRING}
  exit
fi
basePath=${1%/} # Strip any trailing slash

if [ "$(uname)" = "Darwin" ]; then
    os="mac"
elif [ "$(expr substr $(uname -s) 1 5)" = "Linux" ]; then
    os="debian"
fi

if [ "$os" != "debian" ] && [ "$os" != "mac" ]; then
    echo "Operating system could not be automatically detected: this script only works on Debian-based systems and Mac OS X."
    exit
fi
echo "Detected ${os} and installing in ${basePath}"

installFromGitHub() {
    if [ "$#" -ne 2 ]; then
        echo "usage: installFromGit repo-name repo-address"
        exit
    fi

    echo "Installing $1..."
    path="${basePath}/${1}"
    sudo rm -fr ${path}
    git clone ${2} ${path}
    echo "Running setup.py (this can take a while)."
    sudo pip install ${path} > /dev/null 2>&1
    echo "$1 installed"
}

################################### PROMPTS (and dependencies) ###################################
echo "Do you want to install IdProxy (Y/n):"
read INSTALLIDPROXY
if [ "${INSTALLIDPROXY}" = "Y" ]; then
    INSTALLPYOIDC="Y"
    INSTALLPYSAML2="Y"
    INSTALLBASE="Y"
fi

echo "Do you want to install Social2Saml (Y/n):"
read SOCIAL2SAML
if [ "${SOCIAL2SAML}" = "Y" ]; then
    INSTALLPYOIDC="Y"
    INSTALLPYSAML2="Y"
    INSTALLBASE="Y"
fi

echo "Do you want to install verify_entcat (Y/n):"
read VERIFYENTCAT
if [ "${VERIFYENTCAT}" = "Y" ]; then
    INSTALLPYSAML2="Y"
    INSTALLBASE="Y"
fi

echo "Do you want to install dirg-web (Y/n):"
read INSTALLDIRGWEB
if [ "${INSTALLDIRGWEB}" = "Y" ]; then
    INSTALLPYSAML2="Y"
    INSTALLBASE="Y"
fi

echo "Do you want to install saml2test (Y/n):"
read INSTALLSAML2TEST
if [ "${INSTALLSAML2TEST}" = "Y" ]; then
    INSTALLPYSAML2="Y"
    INSTALLBASE="Y"
fi

if [ "${INSTALLPYOIDC}" = "n" ]; then
    echo "Do you want to install pyoidc (Y/n):"
    read INSTALLPYOIDC
    if [ "${INSTALLPYOIDC}" = "Y" ]; then
        INSTALLPYSAML2="Y"
        INSTALLBASE="Y"
    fi
fi

if [ "${INSTALLPYSAML2}" = "n" ]; then
    echo "Do you want to install pysaml2 (Y/n):"
    read INSTALLPYSAML2
    if [ "${INSTALLPYSAML2}" = "Y" ]; then
        INSTALLBASE="Y"
    fi
fi

if [ "${INSTALLOICTESTGUI}" = "n" ]; then
    echo "Do you want to install oictestGui (Y/n):"
    read INSTALLOICTESTGUI
    if [ "${INSTALLOICTESTGUI}" = "Y" ]; then
        INSTALLPYOIDC="Y"
        INSTALLOICTEST="Y"
        INSTALLBASE="Y"
    fi
fi

if [ "${INSTALLOICTEST}" = "n" ]; then
    echo "Do you want to install oictest (Y/n):"
    read INSTALLOICTEST
    if [ "${INSTALLOICTEST}" = "Y" ]; then
        INSTALLPYOIDC="Y"
        INSTALLBASE="Y"
    fi
fi

################################### INSTALLATIONS ###################################

# necessary programs before any installation
if [ "${os}" = "debian" ]; then
        sudo apt-get -y install git gcc wget
    elif [ "${os}" = "mac" ]; then
        ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
        brew doctor
        brew install wget
    fi

if [ "${INSTALLBASE}" = "Y" ]; then
    if [ "${os}" = "debian" ]; then
        sudo apt-get update
        sudo apt-get -y install python-setuptools
        sudo apt-get -y install python-dev
    fi
    wget https://bitbucket.org/pypa/setuptools/raw/bootstrap/ez_setup.py -O - | sudo python
    sudo easy_install -U setuptools
    sudo easy_install pip
    sudo pip install mako
    sudo pip install pycrypto
    sudo pip install cherrypy==3.2.4
    if [ "${os}" = "debian" ]; then
        sudo apt-get -y install python-ldap
    fi
    sudo pip install python-ldap

    echo "______________________________________________________"
    installFromGitHub "pyjwkest" "https://github.com/rohe/pyjwkest"

    echo "______________________________________________________"
    echo "Installing dirg-util..."
    sudo pip install validate_email
    sudo pip install pyDNS
    installFromGitHub "dirg-util" "https://github.com/its-dirg/dirg-util"

    if [ "${os}" = "debian" ]; then
        sudo apt-get -y install libffi-dev
    elif [ "${os}" = "mac" ]; then
        brew install libffi
    fi

    sudo pip install pyOpenSSL==0.13.1
    sudo pip install argparse
    sudo pip install importlib
fi

echo "______________________________________________________"
if [ "${INSTALLPYOIDC}" = "Y" ]; then
    echo "Installing pyoidc..."
    if [ "${os}" = "debian" ]; then
        sudo apt-get -y install swig
        sudo apt-get -y install python-m2crypto
        ./installM2CryptoLinux.sh
    elif [ "${os}" = "mac" ]; then
        brew install swig
        sudo pip install M2Crypto
    fi

    sudo pip install pyOpenSSL
    installFromGitHub "pyoidc" "https://github.com/rohe/pyoidc"
else
    echo "Skipping pyoidc."
fi

echo "______________________________________________________"
if [ "${INSTALLPYSAML2}" = "Y" ]; then
    echo "Installing pysaml2"
    if [ "${os}" = "debian" ]; then
        sudo apt-get -y remove --auto-remove python-crypto
        sudo pip uninstall -y pycrypto
        wget -O ${basePath}/pycrypto-2.6.1.tar.gz https://ftp.dlitz.net/pub/dlitz/crypto/pycrypto/pycrypto-2.6.1.tar.gz
        tar -zxvf pycrypto-2.6.1.tar.gz -f ${basePath}/pycrypto-2.6.1
        sudo pip install "${basePath}/pycrypto-2.6.1" > /dev/null 2>&1
        rm ${basePath}/pycrypto-2.6.1.tar.gz
    fi

    installFromGitHub "pysaml2" "https://github.com/rohe/pysaml2"
    sudo pip install repoze.who
    if [ "${os}" = "debian" ]; then
        sudo apt-get -y install python-dateutil libxmlsec1 xmlsec1 libxmlsec1-openssl libxmlsec1-dev
        sudo apt-get -y install libxml2
        sudo apt-get -y install libtool
    elif [ "${os}" = "mac" ]; then
        brew install libxmlsec1
    fi
else
    echo "Skipping pysaml2."
fi

echo "______________________________________________________"
if [ "${INSTALLSAML2TEST}" = "Y" ]; then
    installFromGitHub "saml2test" "https://github.com/rohe/saml2test"
    installFromGitHub "saml2testGui" "https://github.com/its-dirg/saml2testGui"
else
    echo "Skipping saml2test."
fi
echo "______________________________________________________"

if [ "${SOCIAL2SAML}" = "Y" ]; then
    echo "Installing Social2SAML..."
    installFromGitHub "python-oauth2" "https://github.com/simplegeo/python-oauth2"
    installFromGitHub "IdPproxy" "https://github.com/rohe/IdPproxy"
    echo "Social2SAML installed"
else
    echo "Skipping Social2SAML."
fi

echo "______________________________________________________"
if [ "${INSTALLDIRGWEB}" = "Y" ]; then
    sudo easy_install Beaker
    installFromGitHub "dirg-web" "https://github.com/its-dirg/dirg-web"
else
    echo "Skipping dirg-web."
fi

echo "______________________________________________________"
if [ "${VERIFYENTCAT}" = "Y" ]; then
    installFromGitHub "verify_entcat" "https://github.com/its-dirg/verify_entcat"
else
    echo "Skipping verify_entcat."
fi

echo "______________________________________________________"
if [ "${INSTALLIDPROXY}" = "Y" ]; then
    installFromGitHub "pyYubitool" "https://github.com/HaToHo/pyYubitool"
    installFromGitHub "IdProxy" "https://github.com/its-dirg/IdProxy"
else
    echo "Skipping IdProxy."
fi

echo "______________________________________________________"
if [ "${INSTALLOICTEST}" = "Y" ]; then
    installFromGitHub "oictest" "https://github.com/its-dirg/oictest"
else
    echo "Skipping oictest."
fi

echo "______________________________________________________"
if [ "${INSTALLOICTESTGUI}" = "Y" ]; then
    installFromGitHub "oictestGui" "https://github.com/its-dirg/oictestGui"
else
    echo "Skipping oictestGui."
fi

if [ "${INSTALLPYSAML2}" = "Y" ]; then
    ./configureSaml.sh ${basePath}
fi