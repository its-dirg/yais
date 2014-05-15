#!/usr/bin/env python
# -*- coding: utf-8 -*-
from saml2.cert import OpenSSLWrapper

__author__ = 'haho0032'


cert_info_ca = {
    "cn": "test",
    "country_code": "zz",
    "state": "zz",
    "city": "zzzz",
    "organization": "Zzzzz",
    "organization_unit": "Zzzzz"
}

osw = OpenSSLWrapper()

ca_cert, ca_key = osw.create_certificate(cert_info_ca, request=False, write_to_file=True,
                                                cert_dir="./")