class oi4idp::params {
  include stdlib

  # Hiera
  $idp_shibboleth_version=hiera('toas::idp::idp_shibboleth_version')
  $idp_bas_connector_type=hiera('toas::idp::bas_connector_type')
  $requires_ntp=hiera('toas::idp::requires_ntp', false)
  $toas_bas_ajp_jvm_route=hiera('toas::bas::ajp::jvm_route')
  $authn_LDAP_useStartTLS=hiera('toas::idp::authn_LDAP_useStartTLS', "false")
  $authn_LDAP_useSSL=hiera('toas::idp::authn_LDAP_useSSL', "false")
  $authn_LDAP_trustCertificates=hiera('toas::idp::authn_LDAP_trustCertificates', "%{idp.home}/credentials/ldap-server.crt")
  $authn_LDAP_trustStore=hiera('toas::idp::authn_LDAP_trustStore', "%{idp.home}/credentials/ldap-server.truststore")
  $authn_LDAP_returnAttributes=hiera('toas::idp::authn_LDAP_returnAttributes', "passwordExpirationTime,loginGraceRemaining")
  $authn_LDAP_baseDN=hiera('toas::idp::authn_LDAP_baseDN', "o=toas")
  $authn_LDAP_userFilter=hiera('toas::idp::authn_LDAP_userFilter', "(uid={user})")
  $authn_LDAP_bindDN=hiera('toas::idp::authn_LDAP_bindDN', "uid=admin,ou=system")
  $authn_LDAP_bindDNCredential=hiera('toas::idp::authn_LDAP_bindDNCredential')
  $authn_LDAP_dnFormat=hiera('toas::idp::authn_LDAP_dnFormat', "uid=%s,ou=users,o=toas")
  $authn_LDAP_ldapURL=hiera('toas::idp::authn_LDAP_ldapURL', "ldap://localhost:10389")
  $authn_LDAP_groupBaseDN=hiera('toas::idp::authn_LDAP_groupBaseDN')

  # Static
  $java_home='/usr/lib/jvm/jre'
  $idp_install_path="/opt/shibboleth-idp/"
  $idp_rpm="oi4-idp-${idp_shibboleth_version}"
  $idp_install_home="/opt/shibboleth-idp/bin/"
  $idp_install_script="/root/shibboleth-idp/bin/build.xml"
  $idp_hostname="${::hostname}.${::domain}"

  # Dynamic
  if ($idp_bas_connector_type=="ajp"){
    $idp_bas_server_xml_template="oi4idp/server-ajp.xml.erb"
  }
  else{
    $idp_bas_server_xml_template="oi4idp/server.xml.erb"
  }
  $idp_keystore_password = fqdn_rand_string(20, 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz1234567890~!@#$%^*_-')
}