===========
yais
===========
Yet antoher install script.

This project aims at making it easy to install and configure identity servers and proxies for Raspberry PI enviroments.

The purpose is to make it easy for anyone to get an Raspberry PI test enviroment with Saml IdP:s, SP, OAuh2.0 server and
Open ID connect server.

The project so far have following scripts:

yaisLinux.sh
    This script have the potential to install an IdP proxy to social services, an SAML identity provider(IdP) and a SAML
    service provider(SP). The script will also help you configure an test IdP as well as a test SP.

    The script will give yes and no questions and ask for some metadata information.

    Syntax: yaisLinux.sh install_path
    Example yaisLinux.sh /home/testuser/myinstallation

update.sh
    Run this script to pyjwkest, pysaml2, pyoidc and/or IdPproxy projects. Only already installed projects will be
    updated.

    Syntax: yaisLinux.sh install_path
    Example yaisLinux.sh /home/testuser/myinstallation

configureSaml.sh
    You can use this script to configure an test IdP as well as a test SP.

    Syntax:  configureSaml.sh install_path
    Example: configureSaml.sh /home/testuser/myinstallation


stopIdp.sh
    Run this script to stop your IdP.

stopSp.sh
    Run this script to stop your SP.

