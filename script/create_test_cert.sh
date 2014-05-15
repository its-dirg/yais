#!/bin/sh
openssl genrsa -des3 -out sp.key 1024
openssl req -new -key sp.key -out sp.csr
cp sp.key sp.key.org
openssl rsa -in sp.key.org -out sp.key
openssl x509 -req -days 365 -in sp.csr -signkey sp.key -out sp.crt
