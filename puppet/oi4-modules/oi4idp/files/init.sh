#!/bin/bash
# install ant-contrib (needed by shibboleth idp installation)
echo installing ant contrib:
yum install wget
wget http://downloads.sourceforge.net/project/ant-contrib/ant-contrib/ant-contrib-1.0b2/ant-contrib-1.0b2-bin.tar.gz?r=http%3A%2F%2Fsourceforge.net%2Fprojects%2Fant-contrib%2Ffiles%2Fant-contrib%2Fant-contrib-1.0b2%2F&ts=1448885065&use_mirror=netassist
mv ant-contrib-1.0b2-bin.tar.gz\?r\=http\:%2F%2Fsourceforge.net%2Fprojects%2Fant-contrib%2Ffiles%2Fant-contrib%2Fant-contrib-1.0b2%2F ant-contrib-1.0b2-bin.tar.gz
tar -zxvf ant-contrib-1.0b2-bin.tar.gz
mkdir ant.lib
cp ant-contrib/lib/ant-contrib.jar ant.lib/

#install internet2 antlib (needed by shibboleth idp installation)
echo installing internet2 ant extension:
wget https://build.shibboleth.net/nexus/content/repositories/releases/edu/internet2/middleware/ant-extensions/11Jan2011/ant-extensions-11Jan2011-bin.tar.gz
tar -zxvf ant-extensions-11Jan2011-bin.tar.gz

