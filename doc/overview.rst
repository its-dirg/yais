Overview
########

This project aims at making it easy to install and configure identity servers and proxies for Raspberry PI enviroments.

The purpose is to make it easy for anyone to get an Raspberry PI test enviroment with Saml IdP:s, SP, OAuh2.0 server and
Open ID connect server.

Download the project to your local machine with::

    git clone https://github.com/its-dirg/yais

Got to the directory you installed yais::

    cd [..]/yais

Install yais with the command::

    sudo python setup.py install

The project so far have following scripts:

yaisLinux.sh
    This script have the potential to install an IdP proxy to social services, an SAML identity provider(IdP) and a SAML
    service provider(SP). The script will also help you configure an test IdP as well as a test SP.

    The script will give yes and no questions and ask for some metadata information.

    Syntax: yaisLinux.sh install_path
    Example yaisLinux.sh /home/testuser/myinstallation

update.sh
    Run this script to update pyjwkest, pysaml2, pyoidc and/or IdPproxy projects. Only already installed projects will be
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

startIdp.sh
    Run this script to start your IdP.

    Syntax: startIdp.sh install_path
    Example startIdp.sh /home/testuser/myinstallation

startSp.sh
    Run this script to start your SP.

    Syntax: startSp.sh install_path
    Example startSp.sh /home/testuser/myinstallation

restartIdp.sh
    Run this script to stop the IdP server and then start the IdP server again.

    Syntax: startIdp.sh install_path
    Example startIdp.sh /home/testuser/myinstallation

restartSp.sh
    Run this script to stop the SP server and then start the SP server again.

    Syntax: startSp.sh install_path
    Example startSp.sh /home/testuser/myinstallation