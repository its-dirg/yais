import json
import os
import re
import argparse

from OpenSSL import crypto, SSL
from os.path import exists, join
from yais.Template import TemplateCreator

__author__ = 'haho0032'
#
def create_self_signed_cert(cert_dir):
    CN = raw_input("Input the hostname of the website the certificate is for: ")
    CERT_FILE = "%s.crt" % CN
    KEY_FILE = "%s.key" % CN

    C_F = join(cert_dir, CERT_FILE)
    K_F = join(cert_dir, KEY_FILE)

    if not exists(C_F) or not exists(K_F):
        # create a key pair
        k = crypto.PKey()
        k.generate_key(crypto.TYPE_RSA, 1024)

         # create a self-signed cert
        cert = crypto.X509()
        c = ""
        while(len(c)!=2):
            c = raw_input("Country(2 letters!): ")
        cert.get_subject().C = c
        cert.get_subject().ST = raw_input("State: ")
        cert.get_subject().L = raw_input("City: ")
        cert.get_subject().O = raw_input("Organization: ")
        cert.get_subject().OU = raw_input("Organizational Unit: ")
        cert.get_subject().CN = CN
        cert.set_serial_number(1000)
        cert.gmtime_adj_notBefore(0) #Valid before present time
        cert.gmtime_adj_notAfter(315360000) #3 650 days
        cert.set_issuer(cert.get_subject())
        cert.set_pubkey(k)
        cert.sign(k, 'sha1')

        filesCreated = False
        try:
            fc = open(C_F, "wt")
            fk = open(K_F, "wt")

            fc.write(crypto.dump_certificate(crypto.FILETYPE_PEM, cert))
            fk.write(crypto.dump_privatekey(crypto.FILETYPE_PEM, k))
            filesCreated = True
        except Exception as ex:
            print "Certificate cannot be generated!"
            return None, None

        try:
            fc.close()
        except:
            pass

        try:
            fk.close()
        except:
            pass

        if filesCreated:
            return C_F, K_F
    print "Certificate/key already exist, you have to give the certificate/key another name if you want to generate it."
    answer = raw_input("Do you want to generate certificate file/private key?(Y/n): ")
    if answer == "Y":
        return create_self_signed_cert(cert_dir)
    return None, None


if __name__ == '__main__':
    IDP_PATH = "/pysaml2/example/idp2"

    parser = argparse.ArgumentParser()
    parser.add_argument('-M', dest="metadata", help="Script configuration")
    parser.add_argument(dest="baseDir")
    parser.add_argument(dest="config")
    args = parser.parse_args()

    json_data=open(args.config)
    conf = json.load(json_data)

    sp_metadata_file = None
    if args.metadata is not None:
        sp_metadata_file = args.metadata
        try:
            os.open(sp_metadata_file, os.O_WRONLY | os.O_CREAT | os.O_EXCL)
        except:
            pass

    host = raw_input("Host for the website (empty is the same as localhost): ")
    if len(host.strip()) == 0:
        host = "localhost"

    port=""
    while type(port) != int:
        port = raw_input("Port for the website (empty is the same as 80): ")
        try:
            if len(port.strip()) == 0:
                port = "80"
            port = int(port)
        except:
            print "Port must be an integer!"


    name = "#"
    while not re.match("^[A-Za-z0-9_-]*$", name):
        name = raw_input("Name of the idp (only letters and numbers): ")
        if not re.match("^[A-Za-z0-9_-]*$", name):
            print "The name can only contain numbers and letters!"

    description = ""
    while len(description.strip())==0:
        description = raw_input("Description (may not be empty): ")
        if len(description.strip())==0:
            print "Description may not be empty!"

    while sp_metadata_file is None or not exists(sp_metadata_file):
        if sp_metadata_file is not None:
            print "The metadata file do not exist!"
        sp_metadata_file = raw_input("Give the full path to your sp metadata file: ")

    organisation = ""
    while len(organisation.strip())==0:
        organisation = raw_input("Organisation (may not be empty): ")
        if len(organisation.strip())==0:
            print "Organisation may not be empty!"

    organisationurl = ""
    while len(organisationurl.strip())==0:
        organisationurl = raw_input("Organisation URL (may not be empty): ")
        if len(organisationurl.strip())==0:
            print "Organisation URL may not be empty!"

    contacts = ""
    moreContacts="Y"
    while moreContacts=="Y":
        moreContacts = raw_input("Do you want to add a contact(Y/n): ")
        if moreContacts == "Y":
            contact_type = raw_input("Type of contact: ")
            given_name = raw_input("Given name: ")
            sur_name = raw_input("Sur name: ")
            email_address = raw_input("E-mail adress: ")
            contacts += "{\"contact_type\": \"" + contact_type + \
                        "\", \"given_name\": \"" + given_name + \
                        "\", \"sur_name\": \"" + sur_name + \
                        "\",\"email_address\": \"" + email_address + "\"},"

    answer = raw_input("Do you want to generate certificate file/private key?(Y/n): ")
    cert_file = None
    key_file = None
    if answer == "Y":
        cert_file, key_file = create_self_signed_cert(args.baseDir+"/pki")
    while cert_file is None or not exists(cert_file):
        if cert_file is not None:
            print "The certificate file do not exist!"
        cert_file = raw_input("Give the full path to your certificate: ")
    while key_file is None or not exists(key_file):
        if key_file is not None:
            print "The key file do not exist!"
        key_file = raw_input("Give the full path to your private key: ")

    conf["config"]["replace"].append({"id": "SERVER","value": "http://" + host + ":" + str(port)})
    conf["config"]["replace"].append({"id": "KEYFILE","value": key_file})
    conf["config"]["replace"].append({"id": "CERTFILE","value": cert_file})
    conf["config"]["replace"].append({"id": "NAME", "value": name})
    conf["config"]["replace"].append({"id": "DESCRIPTION","value": description})
    conf["config"]["replace"].append({"id": "LOCALMETADATAPATH","value": sp_metadata_file})
    conf["config"]["replace"].append({"id": "ORGDISPLAYNAME","value": organisation})
    conf["config"]["replace"].append({"id": "ORGNAME", "value": organisation})
    conf["config"]["replace"].append({"id": "ORGURL","value": organisationurl})
    conf["config"]["replace"].append({"id": "CONTACTLIST", "value": contacts})

    TemplateCreator().write_configuration(conf, args.baseDir + IDP_PATH, "../templates/idp/")
