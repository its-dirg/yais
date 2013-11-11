#!/usr/bin/env python
# -*- coding: utf-8 -*-

import json
import os
import re
import argparse

from OpenSSL import crypto, SSL
from os.path import exists, join
from yais.Template import TemplateCreator
from yais.Input import Reader

__author__ = 'haho0032'
#


if __name__ == '__main__':
    SP_PATH = "/pysaml2/example/sp"
    template_file = "/usr/yais/templates/sp/sp_conf.template"


    parser = argparse.ArgumentParser()
    parser.add_argument('-M', dest="metadata", help="Script configuration")
    parser.add_argument('-T', dest="template", help="Full path to template file")
    parser.add_argument(dest="baseDir")
    parser.add_argument(dest="config")


    args = parser.parse_args()

    if args.template is not None:
        template_file = args.template

    json_data=open(args.config)
    conf = json.load(json_data)

    reader = Reader()

    sp_metadata_file = None
    if args.metadata is not None:
        sp_metadata_file = args.metadata
        try:
            os.open(sp_metadata_file, os.O_WRONLY | os.O_CREAT | os.O_EXCL)
        except:
            pass

    host = reader.getHost()
    port = reader.getPort()
    spName = reader.getSpName()
    description = reader.getDescription()
    sp_metadata_file = reader.getSpMetadatafilePath(sp_metadata_file)
    organisation = reader.getOrganisation()
    organisationurl = reader.getOrganisationUrl()
    organisationdisplayname = reader.getOrganisationDisplayNameWithLocal()
    contacts = reader.getContacts()
    cert_file, key_file = reader.getCertAndPrivateKey(args.baseDir + SP_PATH)

    templateCreator = TemplateCreator()

    conf = templateCreator.addReplace(conf, "BASE", "http://" + host + ":" + str(port))
    conf = templateCreator.addReplace(conf, "ENTITYID", spName)
    conf = templateCreator.addReplace(conf, "DESCRIPTION", description)
    conf = templateCreator.addReplace(conf, "NAME", spName)
    conf = templateCreator.addReplace(conf, "KEYFILE", key_file)
    conf = templateCreator.addReplace(conf, "CERTFILE", cert_file)
    conf = templateCreator.addReplace(conf, "LOCALMETADATAPATH", sp_metadata_file)
    conf = templateCreator.addReplace(conf, "ORGANIZATIONNAME", organisation)
    conf = templateCreator.addReplace(conf, "ORGANIZATIONDISPLAYNAME", organisationdisplayname)
    conf = templateCreator.addReplace(conf, "ORGANIZATIONURL", organisationurl)
    conf = templateCreator.addReplace(conf, "CONTACTLIST", contacts)


    conf = templateCreator.addReplace(conf, "ORGNAME", organisation)



    TemplateCreator().write_configuration(conf, args.baseDir + IDP_PATH, template_file)
