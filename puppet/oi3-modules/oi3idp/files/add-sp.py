#!/usr/bin/env python2

#
# This script fetches Shibboleth SP metadata from the given URL and writes it to the
# Shibboleth IdP directory and adds a required XML section to relying-party.xml.
# After these steps are done successfully, Jetty (which runs IdP) is restarted.
# Type ./add-sp.py --help to get information about command line parameters.
#
# The script is invoked over ssh by post-configure.sh script of oi3httpd_sp. The
# expected location of this script is in directory /opt/openinfinity/common/shibboleth-idp.
#
# The only dependency of this file is python2, which is installed in most of modern 
# Linux distros anyway.
#
# In the future, if IdP is clustered, this script has to be improved, to support 
# several IdP nodes and also up-scaling.
#

import sys
import os
import time
from optparse import OptionParser
from xml.dom.minidom import parse

# Parse command line parameters
parser = OptionParser()
parser.add_option("-b", "--shibboleth-base", dest="shibboleth_idp_basedir",
                  help="Shibboleth base directory", metavar="<path>", 
                  default="/opt/shibboleth-idp")
parser.add_option("-u", "--sp-url", dest="sp_url",
                  help="Service Provider URL", metavar="<url>")
parser.add_option("-i", "--sp-id", dest="sp_id",
                  help="Service Provider id", metavar="<id>")
parser.add_option("-d", "--dry-run",
                  action="store_true", dest="dry_run", default=False,
                  help="test the process only by writing results to /tmp instead of the actual directories")
(options, args) = parser.parse_args()
if options.sp_url == None or options.sp_id == None:
    sys.stderr.write("Required parameters missing.\nFor more information type: add-sp.py --help\n")
    sys.exit(1)
    

# Define needed variables
print("Started adding service provider (SP) %s to the local identity provider (IdP)\n" % (options.sp_id))
basedir = options.shibboleth_idp_basedir
sp_filename = "%s/metadata/sp-%s-metadata.xml" % (basedir, options.sp_id)
relying_party_in_filename = "%s/conf/relying-party.xml" % (basedir)
relying_party_out_filename = relying_party_in_filename
if options.dry_run:
    print("Activating dry run mode")
    sp_filename = "/tmp/sp-%s-metadata.xml" % (options.sp_id)
    relying_party_out_filename = "/tmp/relying-party.xml"

# Fetch metafile over http(s) and write it to the local file system
print("Fetching SP metadata from %s" % (options.sp_url))
if 0 != os.system("curl -s -k \"%s\" > %s" % (options.sp_url, sp_filename)):
    sys.stderr.write("Failed to read metadata from %s\n" % (options.sp_url))
    sys.exit(1)
print("Metadata wrote to %s " % (sp_filename))

# Modify IdP XML file /opt/shibboleth-idp/conf/relying-party.xml
print("Modifying file %s" % (relying_party_out_filename))
dom = parse(relying_party_in_filename)
elem = dom.createElement('metadata:MetadataProvider')
elem.setAttribute('id', options.sp_id) # 'SPMetadata')
elem.setAttribute('xsi:type', 'metadata:FilesystemMetadataProvider')
elem.setAttribute('metadataFile', sp_filename)
mp_found = False
for rootnode in dom.childNodes:
    if rootnode.nodeName == "rp:RelyingPartyGroup":
        for rpnodes in rootnode.childNodes:
            if rpnodes.nodeName == "metadata:MetadataProvider": # the chaining provider
                rpnodes.appendChild(elem)
                mp_found = True
if not mp_found:
    sys.stderr.write("Expected chaining metadata provider not found in XML!")
    sys.exit(1)

f = file(relying_party_out_filename, "w")
f.write(dom.toxml())
f.close()

# Restart the service
print("Restarting jetty service")
os.system("/etc/init.d/jetty stop")
time.sleep(2) # as stop seems to return too quickly sometimes, we better use a hack
if 0 != os.system("/etc/init.d/jetty start"):
    sys.stderr.write("Failed to restart the service\n")
    sys.exit(1)

# Success
print("All done.")

