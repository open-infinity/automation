class oi4idp::config {
  require oi4idp::install

  $java_home="${oi4idp::params::java_home}"
  $idp_install_path="${oi4idp::params::idp_install_path}"
  $idp_rpm="${oi4idp::params::idp_rpm}"
  $idp_install_script="${oi4idp::params::idp_install_script}"
  $idp_fqdn="${oi4idp::params::idp_fqdn}"
  $idp_keystore_password= "${oi4idp::params::idp_keystore_password}"
  $idp_bas_server_xml_template="${oi4idp::params::idp_bas_server_xml_template}"
  $clustermember_addresses="${oi4idp::params::clustermember_addresses}"
  $has_attribute_resolver="${oi4idp::params::has_attribute_resolver}"
  $use_special_filters="${oi4idp::params::use_special_filters}"
  $authn_LDAP_useStartTLS="${oi4idp::params::authn_LDAP_useStartTLS}"
  $authn_LDAP_useSSL="${oi4idp::params::authn_LDAP_useSSL}"
  $authn_LDAP_trustCertificates="${oi4idp::params::authn_LDAP_trustCertificates}"
  $authn_LDAP_trustStore="${oi4idp::params::authn_LDAP_trustStore}"
  $authn_LDAP_returnAttributes="${oi4idp::params::authn_LDAP_returnAttributes}"
  $authn_LDAP_baseDN="${oi4idp::params::authn_LDAP_baseDN}"
  $authn_LDAP_userFilter="${oi4idp::params::authn_LDAP_userFilter}"
  $authn_LDAP_bindDN="${oi4idp::params::authn_LDAP_bindDN}"
  $authn_LDAP_bindDNCredential="${oi4idp::params::authn_LDAP_bindDNCredential}"
  $authn_LDAP_dnFormat="${oi4idp::params::authn_LDAP_dnFormat}"
  $authn_LDAP_ldapURL="${oi4idp::params::authn_LDAP_ldapURL}"
  $authn_LDAP_groupBaseDN="${oi4idp::params::authn_LDAP_groupBaseDN}"

  file {"${idp_install_script}":
    content => template("oi4idp/build.xml.erb"),
    ensure  => present,
    replace => true,
    owner   => "root",
    group   => "root",
    mode    => 0644,
  }
  file { "/opt/openinfinity/tomcat/conf/server.xml":
    content => template("$idp_bas_server_xml_template"),
    ensure  => present,
    replace => true,
    owner   => "root",
    group   => "root",
    mode    => 0644,
    notify  => Service["oi-tomcat"]
  }
  exec { "install_idp":
    command     => "/root/shibboleth-idp/bin/install.sh",
    cwd         => "/root/shibboleth-idp/bin/",
    environment => "JAVA_HOME=${java_home}",
    creates     => "$idp_install_path/war/idp.war",
    require => File["/opt/openinfinity/tomcat/conf/server.xml"]
  }
  file { "${idp_install_path}":
    ensure  => directory,
    recurse => true,
    owner   => "oiuser",
    mode    => 0644,
    require => File["install_idp"]
  }
  file { "/opt/openinfinity/tomcat/conf/Catalina/":
    ensure => directory,
    owner  => "root",
    group  => "root",
    mode   => 755,
  }
  file { "/opt/openinfinity/tomcat/conf/Catalina/localhost/":
    ensure  => directory,
    owner   => "root",
    group   => "root",
    mode    => 755,
    require => File["/opt/openinfinity/tomcat/conf/Catalina"],
  }
  file { "/opt/openinfinity/tomcat/conf/Catalina/localhost/idp.xml":
    ensure  => present,
    owner   => 'oiuser',
    group   => 'oiuser',
    mode    => 0644,
    source  => "puppet:///modules/oi4idp/idp.xml",
    require => File["/opt/openinfinity/tomcat/conf/Catalina/localhost"],
    notify  => Service["oi-tomcat"]
  }
  if ($use_special_filters == true){
    file { "/opt/shibboleth-idp/webapp/WEB-INF/web.xml":
      ensure  => present,
      owner   => 'oiuser',
      group   => 'oiuser',
      mode    => 0644,
      source  => "puppet:///modules/oi4idp/web.xml",
      require => File["install_idp"],
      notify  => Service["oi-tomcat"]
    }
  }
  file { "/opt/openinfinity/tomcat/lib/opt":
    ensure => directory,
    owner  => "root",
    group  => "root",
    mode   => 755,
  }
  file { "/opt/openinfinity/scripts":
    ensure => directory,
    owner  => "oiuser",
    group  => "oiuser",
    mode   => 755,
  }
  file { "/opt/openinfinity/scripts/setscriptpermissions.sh":
    ensure => present,
    owner  => 'root',
    group  => 'root',
    mode   => 0700,
    source => "puppet:///modules/oi4idp/setscriptpermissions.sh",
    notify => Service["oi-tomcat"],
    require => File["/opt/openinfinity/scripts"]
  }
  exec { "/opt/openinfinity/scripts/setscriptpermissions.sh":
    command => "/opt/openinfinity/scripts/setscriptpermissions.sh",
    require => File["/opt/openinfinity/scripts/setscriptpermissions.sh"]
  }
  file { "/opt/openinfinity/common/shibboleth-idp/":
    ensure => directory,
    owner  => "root",
    group  => "root",
    mode   => 755,
  }
  file { "/opt/shibboleth-idp/conf/metadata-providers.xml":
    ensure => present,
    owner  => 'oiuser',
    group  => 'root',
    mode   => 0640,
    require => File["install_idp"],
    source => "puppet:///modules/oi4idp/metadata_providers.xml",
  }
  if ($has_attribute_resolver == true){
    file { "/opt/shibboleth-idp/conf/attribute-resolver.xml":
      content => template("oi4idp/attribute-resolver.xml.erb"),
      ensure  => present,
      replace => true,
      owner   => "oiuser",
      group   => "root",
      mode    => 0644,
      require => File["install_idp"],
    }
  }
  file { "/opt/shibboleth-idp/conf/attribute-filter.xml":
    source  => "puppet:///modules/oi4idp/attribute-filter.xml",
    ensure  => present,
    replace => true,
    owner   => "oiuser",
    group   => "root",
    mode    => 0644,
    require => File["install_idp"],
  }
  file { "/opt/shibboleth-idp/conf/ldap.properties":
    content => template("oi4idp/ldap.properties.erb"),
    ensure  => present,
    replace => true,
    owner   => "oiuser",
    group   => "root",
    mode    => 0644,
    require => File["install_idp"],
  }
  file { "/opt/shibboleth-idp/conf/authn/jaas.config":
    content => template("oi4idp/jaas.config.erb"),
    ensure  => present,
    replace => true,
    owner   => "oiuser",
    group   => "root",
    mode    => 0644,
    require => File["install_idp"],
  }
  file { "/opt/shibboleth-idp/conf/global.xml":
    content => template("oi4idp/global.xml.erb"),
    ensure  => present,
    replace => true,
    owner   => "oiuser",
    group   => "root",
    mode    => 0644,
    require => File["install_idp"],
  }
  file_line { "memcahced for attributes":
    path  => "/opt/shibboleth-idp/conf/idp.properties",
    ensure  => present,
    line    => "idp.artifact.StorageService = shibboleth.MemcachedStorageService",
    match   => "#idp.artifact.StorageService = shibboleth.StorageService",
    require => File["install_idp"],
  }
  file_line { "memcahced for consent":
    path  => "/opt/shibboleth-idp/conf/idp.properties",
    ensure  => present,
    line    => "idp.consent.StorageService = shibboleth.MemcachedStorageService",
    match   => "#idp.consent.StorageService = shibboleth.ClientPersistentStorageService",
    require => File["install_idp"],
  }
  file_line { "memcahced for message replay":
    path  => "/opt/shibboleth-idp/conf/idp.properties",
    ensure  => present,
    line    => "idp.replayCache.StorageService = shibboleth.MemcachedStorageService",
    match   => "#idp.replayCache.StorageService = shibboleth.StorageService",
    require => File["install_idp"],
  }
}
