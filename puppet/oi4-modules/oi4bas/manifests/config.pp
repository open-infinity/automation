class oi4bas::config (
  $bas_multicast_address = undef,
  $bas_tomcat_monitor_role_pwd = undef,
  $oi_home = '/opt/openinfinity',
  $ignore_catalina_propeties = undef,
  $sso_attribute_session_identifier = undef,
  $sso_attribute_session_username = undef,
  $sso_attribute_session_tenant_id = undef,
  $sso_attribute_session_roles = undef,
  $sso_attribute_session_role_delimiter = undef,
  $sso_attribute_session_attributes = undef,
  $sso_attribute_session_user_attribute_delimiter = undef,
  $sso_header_session_identifier = undef,
  $sso_header_session_username = undef,
  $sso_header_session_tenant_id = undef,
  $sso_header_session_roles = undef,
  $sso_header_session_role_delimiter = undef,
  $sso_header_session_attributes = undef,
  $sso_header_session_user_attribute_delimiter = undef,
  $bas_hazelcast_cluster_nodes = undef
) 

{
if ! $ignore_catalina_propeties {

  file {"$oi_home/tomcat/conf/catalina.properties":
    ensure => present,
    owner => 'oiuser',
    group => 'oiuser',
    mode => 0600,
    source => "puppet:///modules/oi4bas/catalina.properties",
    require => Class["oi4bas::install"],
    notify => Service["oi-tomcat"],
  }
}

  # Security Vault configuration
  file {"$oi_home/tomcat/conf/securityvault.properties":
    ensure => present,
    owner => 'oiuser',
    group => 'oiuser',
    mode => 0600,
    content => template("oi4bas/securityvault.properties.erb"),
    require => Class["oi4bas::install"],
  }
  
  if ( $bas_multicast_address == undef ) {
    if ( $bas_hazelcast_cluster_nodes == undef ) {
		fail ("Cluster members are not defined. Cannot continue.")
	}	
	file {"$oi_home/tomcat/conf/hazelcast.xml":
		ensure => present,
		owner => 'oiuser',
		group => 'oiuser',
		mode => 0600,
		content => template("oi4bas/hazelcast-tcp-cluster.xml.erb"),
		require => Class["oi4bas::install"],
	  }

  } else 
  {
	  file {"$oi_home/tomcat/conf/hazelcast.xml":
		ensure => present,
		owner => 'oiuser',
		group => 'oiuser',
		mode => 0600,
		content => template("oi4bas/hazelcast.xml.erb"),
		require => Class["oi4bas::install"],
	  }
  
  }

  file {"/etc/init.d/oi-tomcat":
    ensure => present,
    owner => 'root',
    group => 'root',
    mode => 0755,
    content => template("oi4bas/oi-tomcat.erb"),
    require => Class["oi4bas::install"],
  }

  file {"$oi_home/tomcat/conf/jmxremote.password":
    ensure => present,
    owner => 'oiuser',
    group => 'oiuser',
    mode => 0600,
    content => template("oi4bas/jmxremote.password.erb"),
    require => Class["oi4bas::install"],
  }

  file {"$oi_home/tomcat/conf/jmxremote.access":
    ensure => present,
    owner => 'oiuser',
    group => 'oiuser',
    mode => 0644,
    source => "puppet:///modules/oi4bas/jmxremote.access",
    require => Class["oi4bas::install"],
  }

}


