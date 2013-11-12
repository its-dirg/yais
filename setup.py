# -*- coding: utf-8 -*-
from distutils.core import setup

setup(
    name="yais",
    version="0.1",
    description='Yet antoher install script ',
    author = "Hans, Hoerberg",
    author_email = "hans.horberg@umu.se",
    license="Apache 2.0",
    package_dir = {"": "src"},
    classifiers = ["Development Status :: 4 - Beta",
        "License :: OSI Approved :: Apache Software License",
        "Topic :: Software Development :: Libraries :: Python Modules"],
    install_requires = [],
    scripts=["script/configureSaml.sh",
             "script/create_key.sh",
             "script/installM2CryptoLinux.sh",
             "script/restartIdp.sh",
             "script/restartSp.sh",
             "script/setupIdp.py",
             "script/setupSp.py",
             "script/startIdp.sh",
             "script/startSp.sh",
             "script/stopIdp.sh",
             "script/stopSp.sh",
             "script/yaisupdate.sh",
             "script/yaisLinux.sh"
             ],
    zip_safe=False,
    packages=['yais'],
    data_files=[
        ("/usr/yais/templates/idp", [
                                        "templates/idp/create_testserver_idp_conf.json",
                                        "templates/idp/idp_conf.template"
                                    ]),
        ("/usr/yais/templates/sp", [
                                        "templates/sp/create_testclient_sp_conf.json",
                                        "templates/sp/sp_conf.template"
                                    ]),
    ]

)