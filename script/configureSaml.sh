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
basePath=$1
pysaml2Path="$basePath/pysaml2"
echo "Do you want to configure an test IdP and SP? (Y/n):"
read CONFIGUREIDPSP
if [ $CONFIGUREIDPSP = "Y" ]
then
  sudo easy_install pyopenssl
  idpConfFile="$pysaml2Path/example/idp2/idp_conf.py"
  idpMetadataFile="$pysaml2Path/example/idp2/idp_conf.xml"
  spConfFile="$pysaml2Path/example/sp/sp_conf.py"
  spMetadataFile="$pysaml2Path/example/sp/sp_conf.xml"
  echo "IdP setup"
  setupIdp.py $basePath /usr/yais/templates/idp/create_testserver_idp_conf.json -M $spMetadataFile
  echo "SP setup"
  setupSp.py $basePath /usr/yais/templates/sp/create_testclient_sp_conf.json -M $idpMetadataFile
  cd "$pysaml2Path/example/idp2"
  make_metadata.py idp_conf.py > idp_conf.xml
  cd "$pysaml2Path/example/sp"
  make_metadata.py sp_conf.py > sp_conf.xml
  echo "Do you want to start test IdP and SP? (Y/n):"
  read STARTCONFIGUREIDPSP
  if [ $STARTCONFIGUREIDPSP = "Y" ]
  then
    restartIdp.sh $basePath
    restartSp.sh $basePath
  fi
fi