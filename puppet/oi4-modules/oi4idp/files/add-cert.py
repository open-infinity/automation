#!/usr/bin/env python2

import sys
import os
import textwrap 
from xml.dom.minidom import parse

# Parameters
cert_file_path = '/opt/shibboleth-idp/credentials/idp.crt'
idp_metadata_path = '/opt/shibboleth-idp/metadata/idp-metadata.xml'

# Read the cert file
certfile = open(cert_file_path, 'r').readlines()

#remove first and last line
certfile.pop(0)
del certfile[-1]

newcert = "\n"
rawcert = ""

for line in certfile:
    rawcert += line

rawcert_as_string = rawcert.replace("\n", "")

newcert += '\n'.join(textwrap.wrap(rawcert_as_string, 64))
newcert += "\n\n"

dom = parse(idp_metadata_path)

nodes = dom.getElementsByTagName("ds:X509Certificate")
for node in nodes:
    if node.firstChild.nodeType != node.TEXT_NODE:
        raise Exception("Cert Data missing")
    node.firstChild.replaceWholeText(newcert)

f = file(idp_metadata_path, "w")
f.write(dom.toxml())
f.close()

