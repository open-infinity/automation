#!/bin/bash

yum install wget
wget http://downloads.sourceforge.net/project/ant-contrib/ant-contrib/ant-contrib-1.0b2/ant-contrib-1.0b2-bin.tar.gz?r=http%3A%2F%2Fsourceforge.net%2Fprojects%2Fant-contrib%2Ffiles%2Fant-contrib%2Fant-contrib-1.0b2%2F&ts=1448885065&use_mirror=netassist
mv ant-contrib-1.0b2-bin.tar.gz\?r\=http\:%2F%2Fsourceforge.net%2Fprojects%2Fant-contrib%2Ffiles%2Fant-contrib%2Fant-contrib-1.0b2%2F ant-contrib-1.0b2-bin.tar.gz
tar -zxvf ant-contrib-1.0b2-bin.tar.gz
mkdir ant.lib
cp ant-contrib/lib/ant-contrib.jar ant.lib/
