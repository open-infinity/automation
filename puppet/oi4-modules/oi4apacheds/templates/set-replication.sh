#!/bin/bash
/usr/bin/ldapmodify -h localhost -p 10389 -D "uid=admin,ou=system" -w ___SET_ME___ -a -f replication.ldif