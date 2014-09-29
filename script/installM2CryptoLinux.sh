#!/bin/sh -xe

# Sets up m2crypto on ubuntu architecture in virtualenv
# openssl 1.0 does not have sslv2, which is not disabled in m2crypto
# therefore this workaround is required

PATCH="
--- SWIG/_ssl.i 2011-01-15 20:10:06.000000000 +0100
+++ SWIG/_ssl.i 2012-06-17 17:39:05.292769292 +0200
@@ -48,8 +48,10 @@
 %rename(ssl_get_alert_desc_v) SSL_alert_desc_string_long;
 extern const char *SSL_alert_desc_string_long(int);

+#ifndef OPENSSL_NO_SSL2
 %rename(sslv2_method) SSLv2_method;
 extern SSL_METHOD *SSLv2_method(void);
+#endif
 %rename(sslv3_method) SSLv3_method;
 extern SSL_METHOD *SSLv3_method(void);
 %rename(sslv23_method) SSLv23_method;"

pip install --download="." m2crypto
tar -xf M2Crypto-*.tar.gz
rm M2Crypto-*.tar.gz
cd M2Crypto-*
echo "$PATCH" | patch -p0
sudo python setup.py install
cd ..
sudo rm -fr M2Crypto-*