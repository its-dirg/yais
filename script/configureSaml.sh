#!/bin/sh
if [ $1 = "-h" ]
then
    echo "usage: setupLinux.sh pysaml2_path"
fi
if [ ! -d "$1" ]; then
  echo "$1 is not a directory!"
  echo "usage: setupLinux.sh pysaml2_path"
  exit
fi
pysaml2Path=$1
echo "Do you want to configure an test IdP and SP? (Y/n):"
read CONFIGUREIDPSP
if [ $CONFIGUREIDPSP = "Y" ]
then
#  sudo easy_install pyopenssl
  idpConfFile="$pysaml2Path/example/idp/yaisIdpConf.py"
  spConfFile="$pysaml2Path/example/idp/yaisSpConf.py"
  spMetadataFile="$pysaml2Path/example/sp/yaisSp.xml"
  idpMetadataFile="$pysaml2Path/example/idp/yaisIdp.xml"
  echo "IdP setup"
  sudo setupIdp.py $pysaml2Path /usr/yais/templates/idp/create_testserver_idp_conf.json -M $spMetadataFile
  echo "SP setup"
  sudo setupSp.py $pysaml2Path /usr/yais/templates/sp/create_testclient_sp_conf.json -M idpMetadataFile
  make_metadata.py $idpConfFile > idpMetadataFile
  make_metadata.py $spConfFile > spMetadataFile
  echo "Do you want to start test IdP and SP? (Y/n):"
  read STARTCONFIGUREIDPSP
  if [ $STARTCONFIGUREIDPSP = "Y" ]
  then
    `$pysaml2Path/example/idp/idp.py $idpConfFile`
    `$pysaml2Path/example/sp/sp.py $spConfFile`
  fi
fi