#!/bin/bash
/usr/bin/ldapmodify -h localhost -p 10389 -D "uid=admin,ou=system" -w secret -a -f admin-pwd.ldif