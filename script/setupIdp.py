#!/usr/bin/env python
# -*- coding: utf-8 -*-

__author__ = 'haho0032'
import json
import os
import re
import argparse

from OpenSSL import crypto, SSL
from os.path import exists, join
from yais.Template import TemplateCreator
from yais.Input import Reader

#


if __name__ == '__main__':
    IDP_PATH = "/pysaml2/example/idp2"
    template_file = "/usr/yais/templates/idp/idp_conf.template"

    parser = argparse.ArgumentParser()
    parser.add_argument('-M', dest="metadata", help="Script configuration")
    parser.add_argument('-T', dest="template", help="Full path to template file")
    parser.add_argument(dest="baseDir")
    parser.add_argument(dest="config")
    args = parser.parse_args()

    json_data=open(args.config)
    conf = json.load(json_data)

    reader = Reader()

    if args.template is not None:
        template_file = args.template

    sp_metadata_file = None
    if args.metadata is not None:
        sp_metadata_file = args.metadata
        try:
            os.open(sp_metadata_file, os.O_WRONLY | os.O_CREAT | os.O_EXCL)
        except:
            pass

    host = reader.getHost()
    port = reader.getPort()
    entityid = reader.getEntityId()
    description = reader.getDescription()
    sp_metadata_file = reader.getSpMetadatafilePath(sp_metadata_file)
    organisation = reader.getOrganisation()
    organisationurl = reader.getOrganisationUrl()
    contacts = reader.getContacts()
    cert_file, key_file = reader.getCertAndPrivateKey(args.baseDir + IDP_PATH)

    templateCreator = TemplateCreator()

    conf = templateCreator.addReplace(conf, "HOST", host)
    conf = templateCreator.addReplace(conf, "PORT", str(port))
    conf = templateCreator.addReplace(conf, "KEYFILE", key_file)
    conf = templateCreator.addReplace(conf, "CERTFILE", cert_file)
    conf = templateCreator.addReplace(conf, "ENTITYID", entityid)
    conf = templateCreator.addReplace(conf, "DESCRIPTION", description)
    conf = templateCreator.addReplace(conf, "LOCALMETADATAPATH", sp_metadata_file)
    conf = templateCreator.addReplace(conf, "ORGDISPLAYNAME", organisation)
    conf = templateCreator.addReplace(conf, "ORGNAME", organisation)
    conf = templateCreator.addReplace(conf, "ORGURL", organisationurl)
    conf = templateCreator.addReplace(conf, "CONTACTLIST", contacts)

    TemplateCreator().write_configuration(conf, args.baseDir + IDP_PATH, template_file)
