#!/usr/bin/env python
# -*- coding: utf-8 -*-
from saml2 import BINDING_HTTP_REDIRECT, BINDING_URI
from saml2 import BINDING_HTTP_ARTIFACT
from saml2 import BINDING_HTTP_POST
from saml2 import BINDING_SOAP
from saml2.saml import NAME_FORMAT_URI
from saml2.saml import NAMEID_FORMAT_TRANSIENT
from saml2.saml import NAMEID_FORMAT_PERSISTENT

try:
    from saml2.sigver import get_xmlsec_binary
except ImportError:
    get_xmlsec_binary = None

if get_xmlsec_binary:
    xmlsec_path = get_xmlsec_binary(["/opt/local/bin","/usr/local/bin"])
else:
    xmlsec_path = '/usr/local/bin/xmlsec1'

BASE = "http://localhost:8999"

CONFIG = {
    "entityid": "%s/idp.xml" % BASE,
    "description": "My cool idp",
    "service": {
        "idp": {
            "name": "idp",
            "endpoints": {
                "single_sign_on_service": [
                    ("%s/sso/redirect" % BASE, BINDING_HTTP_REDIRECT),
                    ("%s/sso/post" % BASE, BINDING_HTTP_POST),
                    ("%s/sso/art" % BASE, BINDING_HTTP_ARTIFACT),
                    ("%s/sso/ecp" % BASE, BINDING_SOAP)
                ],
                "single_logout_service": [
                    ("%s/slo/soap" % BASE, BINDING_SOAP),
                    ("%s/slo/post" % BASE, BINDING_HTTP_POST),
                    ("%s/slo/redirect" % BASE, BINDING_HTTP_REDIRECT)
                ],
            },
            "policy": {
                "default": {
                    "lifetime": {"minutes": 15},
                    "attribute_restrictions": None, # means all I have
                    "name_form": NAME_FORMAT_URI,
                    "entity_categories": ['swamid', 'edugain']
                },
            },
            "subject_data": "./idp.subject",
            "name_id_format": [NAMEID_FORMAT_TRANSIENT,
                               NAMEID_FORMAT_PERSISTENT]
        },
    },
    "debug": 1,
    "key_file": "/Users/haho0032/github/yais/test/idp/pki/localhost.key",
    "cert_file": "/Users/haho0032/github/yais/test/idp/pki/localhost.crt",
    "metadata": {
            "local": ["/Users/haho0032/github/yais/test/idp/pysaml2/example/idp2/sp.xml"],
    },
    "organization": {
        "display_name": "Qwerty",
        "name": "Qwerty",
        "url": "http://www.qwerty.com",
    },
    "contact_person": [
        {"contact_type": "support", "given_name": "Qwerty", "sur_name": "Qwerty","email_address": "qwerty@qwerty.com"},{"contact_type": "Ytrewq", "given_name": "Ytrewq", "sur_name": "Ytrewq","email_address": "ytrewq@qwerty.com"},
    ],
    # This database holds the map between a subjects local identifier and
    # the identifier returned to a SP
    "xmlsec_binary": xmlsec_path,
    "attribute_map_dir": "../attributemaps",
    "logger": {
        "rotating": {
            "filename": "idp.log",
            "maxBytes": 500000,
            "backupCount": 5,
        },
        "loglevel": "debug",
    }
}
