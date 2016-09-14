#!/bin/bash -e

# author wlodamac
# This script takes as parameters url of the idp server and installation path of idp (usually: "/opt/shibboleth-idp") and 
# password to protect Java keystore
# It requires java keytool and openssl to be installed

idp_url=$1
idp_install_path=$2
cert_password=$3 #"$(openssl rand -base64 32)" 

keystore="$idp_install_path/credentials/idp.jks"
cert_file="$idp_install_path/credentials/idp.crt"
key_file="$idp_install_path/credentials/idp.key"
tmp_key="$idp_install_path/credentials/idp.crypto.key"
tmp_pkcs12="$idp_install_path/credentials/cert.p12"

#Generate new key and self-signed certificate valid for 20 years
keytool -genkey -keyalg RSA -sigalg SHA1WithRSA -alias $idp_url -keystore $keystore -storepass $cert_password -keypass $cert_password -validity 7300 -keysize 2048 -dname CN=$idp_url -ext san=dns:$idp_url,uri:https://$idp_url/idp/shibboleth

#Export cert
keytool -export -keystore $keystore -alias $idp_url -rfc -storepass $cert_password > $cert_file

#Export private key:
keytool -v -importkeystore -srckeystore $keystore -srcalias $idp_url -destkeystore $tmp_pkcs12 -deststoretype PKCS12 -srcstorepass $cert_password -deststorepass $cert_password

openssl pkcs12 -in $tmp_pkcs12 -nocerts -passin pass:$cert_password -passout pass:$cert_password -out $tmp_key
openssl rsa -in $tmp_key -out $key_file -passin pass:$cert_password

rm -rf $tmp_key $tmp_pkcs12

# TODO: this needs to be changes depending on the script location on the target node  
/etc/puppet/modules/oi4idp/files/add-cert.py
 
