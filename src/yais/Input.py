# -*- coding: utf-8 -*-
from yais.Log import create_logger

__author__ = 'haho0032'
import json
import os
import re
import argparse

from OpenSSL import crypto, SSL
from os.path import exists, join

class Reader:

    def __init__(self):
        self.logger = create_logger("yais_input.log")

    def create_self_signed_cert(self, cert_dir):
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
                fc = open(C_F, "wt") #Do not work on linux, try with os.open instead.
                fk = open(K_F, "wt")

                fc.write(crypto.dump_certificate(crypto.FILETYPE_PEM, cert))
                fk.write(crypto.dump_privatekey(crypto.FILETYPE_PEM, k))
                filesCreated = True
            except Exception as ex:
                self.logger.error("Certificate cannot be generated! Exception: " + ex.message)
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
            return self.create_self_signed_cert(cert_dir)
        return None, None

    def getIntWithDefault(self, message, error_message, default):
        value=""
        while type(value) != int:
            value = raw_input(message)
            try:
                if len(value.strip()) == 0:
                    value = default
                value = int(value)
            except:
                print error_message
        return value

    def getLettersAndNumbersOnly(self, message, error_message):
        value = "#"
        while not re.match("^[A-Za-z0-9_-]*$", value):
            value = raw_input(message)
            if not re.match("^[A-Za-z0-9_-]*$", value) or len(value.strip())==0:
                print error_message
        return value

    def getNoneEmptyString(self, message, error_message):
        value = ""
        while len(value.strip())==0:
            value = raw_input(message)
            if len(value.strip())==0:
                print error_message
        return value

    def getFilePath(self, message, error_message, filePath=None):
        while filePath is None or not exists(filePath):
            if filePath is not None:
                print message
            filePath = raw_input(error_message)
        return filePath

    def getTwoSmallLetters(self, message, error_message):
        value = ""
        while not re.match("^[a-z]*$", value) or (len(value)!=2):
            value = raw_input(message)
            if not re.match("^[a-z]*$", value) or (len(value)!=2):
                print error_message
        return value

    def getHost(self, default="localhost"):
        host = raw_input("Host for the website (empty is the same as localhost): ")
        if len(host.strip()) == 0:
            host = default
        return host

    def getPort(self, default=80):
        return self.getIntWithDefault("Port for the website (empty is the same as 80): ",
                                      "Port must be an integer!", str(default))

    def getEntityId(self):
        return self.getLettersAndNumbersOnly("Name of the idp (only letters and numbers): ",
                                             "The name can only contain numbers and letters!")

    def getSpName(self):
        return self.getLettersAndNumbersOnly("Name of the sp (only letters and numbers): ",
                                             "The name can only contain numbers and letters!")


    def getDescription(self):
        return self.getNoneEmptyString("Description (may not be empty): ", "Description may not be empty!")

    def getSpMetadatafilePath(self, metadata_file):
        return self.getFilePath("Give the full path to your sp metadata file: ",
                                "The metadata file do not exist!", metadata_file)

    def getIdpMetadatafilePath(self, metadata_file):
        return self.getFilePath("Give the full path to your idp metadata file: ",
                                "The metadata file do not exist!", metadata_file)

    def getOrganisation(self):
        return self.getNoneEmptyString("Organisation (may not be empty): ", "Organisation may not be empty!")

    def getOrganisationUrl(self):
        return self.getNoneEmptyString("Organisation URL (may not be empty): ", "Organisation URL may not be empty!")

    def getContacts(self):
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
        return contacts

    def getCertAndPrivateKey(self, baseDir):
        answer = raw_input("Do you want to generate certificate file/private key?(Y/n): ")
        cert_file = None
        key_file = None
        if answer == "Y":
            cert_file, key_file = self.create_self_signed_cert(baseDir+"/pki")
        while cert_file is None or not exists(cert_file):
            if cert_file is not None:
                print "The certificate file do not exist!"
            cert_file = raw_input("Give the full path to your certificate: ")
        while key_file is None or not exists(key_file):
            if key_file is not None:
                print "The key file do not exist!"
            key_file = raw_input("Give the full path to your private key: ")
        return cert_file, key_file

    def getOrganisationDisplayNameWithLocal(self):
        answer = "Y"
        orgnames = None
        while (answer=="Y"):
            name = self.getNoneEmptyString("Organisation displayname (may not be empty): ",
                                           "Organisation display name may not be empty!")
            local = self.getTwoSmallLetters("Local (only two lowercase letters): ",
                                            "Only two lowercase letters allowed!")
            if orgnames is None:
                orgnames = "(\"" + name + "\", \"" + local + "\")"
            else:
                orgnames += ", (\"" + name + "\", \"" + local + "\")"
            answer = raw_input("Do you want to add an organisation display in another language?(Y/n): ")
        return orgnames
