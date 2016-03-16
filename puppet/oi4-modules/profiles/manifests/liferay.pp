class profiles::liferay {
  $multicast_address = hiera('toas::portal:multicast_address', 'placeholder')
  $db_address = hiera('toas::portal::db_address')
  $db_password = hiera('toas::portal::db_password')
  $tomcat_monitor_role_password = hiera('toas::portal::tomcat_monitor_role_password')
  $jvm_mem = hiera('toas::portal::jvm_mem', '2048')
  $jvm_perm = hiera('toas::portal::jvm_perm', '512')
  $extra_jvm_opts = hiera('toas::portal::extra_jvm_opts', undef)
  $extra_catalina_opts = hiera('toas::portal::extra_catalina_opts', undef)
  $use_ee_version = hiera('toas::portal::use_ee', false)
  $enable_cluster = hiera('toas::portal::enable_cluster', 'true')
  $hazelcast_cluster_nodes = hiera('toas::hazelcast::nodes', undef)
  # Session attribute identifiers
$sso_attribute_session_identifier = hiera('sso::attribute::session::identifier', 'Shib-Session-ID')
$sso_attribute_session_username = hiera('sso::attribute::session::username','uid')
$sso_attribute_session_tenant_id = hiera('sso::attribute::session::tenant::id','tenantId')
$sso_attribute_session_roles = hiera('sso::attribute::session::roles','roles')
$sso_attribute_session_role_delimiter = hiera('sso::attribute::session::role::delimiter',',')
$sso_attribute_session_attributes = hiera('sso::attribute::session::attributes','name,address,phone')
$sso_attribute_session_user_attribute_delimiter = hiera('sso::attribute::session::user::attribute::delimiter', ',')

# Session header identifiers
$sso_header_session_identifier = hiera('sso::header::session::identifier','iv-user')
$sso_header_session_username = hiera('sso::header::session::username','iv-user')
$sso_header_session_tenant_id = hiera('sso::header::session::tenant::id','iv-groups')
$sso_header_session_roles = hiera('sso::header::session::roles','iv-groups')
$sso_header_session_role_delimiter = hiera('sso::header::session::role::delimiter',',')
$sso_header_session_attributes = hiera('sso::header::session::attributes','name,address,phone')
$sso_header_session_user_attribute_delimiter = hiera('sso::header::session::user::attribute::delimiter',',')

  
  if ( $use_ee_version )  {
	$liferay_package_name = 'oi4-liferay-ee' 
  } else 
  {
	$liferay_package_name = 'oi4-liferay' 
  }
  
  $oi_home = hiera('toas::oi_home', '/opt/openinfinity')

  file {"$oi_home/log/tomcat":
    ensure  => 'directory',
    owner   => 'oiuser',
    group   => 'oiuser',
    mode    => 755,
    require => [User["oiuser"], File["$oi_home/log"]],
  }->
  class {'oi4portal::install': 
	liferay_package_name => $liferay_package_name,
  }->
  class {'oi4portal::config':
    portal_multicast_address            => $multicast_address,
    portal_db_address                   => $db_address,
    portal_db_password                  => $db_password,
    portal_tomcat_monitor_role_password => $tomcat_monitor_role_password,
    portal_extra_jvm_opts               => $extra_jvm_opts,
    portal_extra_catalina_opts          => $extra_catalina_opts,
    portal_jvmmem                       => $jvm_mem,
    portal_jvmperm                      => $jvm_perm,
	enable_cluster						=> $enable_cluster, 
	sso_attribute_session_identifier => $sso_attribute_session_identifier,
	sso_attribute_session_username => $sso_attribute_session_username,
	sso_attribute_session_tenant_id => $sso_attribute_session_tenant_id,
	sso_attribute_session_roles => $sso_attribute_session_roles,
	sso_attribute_session_role_delimiter => $sso_attribute_session_role_delimiter,
	sso_attribute_session_attributes => $sso_attribute_session_attributes,
	sso_attribute_session_user_attribute_delimiter => $sso_attribute_session_user_attribute_delimiter,
	sso_header_session_identifier => $sso_header_session_identifier,
	sso_header_session_username => $sso_header_session_username,
	sso_header_session_tenant_id => $sso_header_session_tenant_id,
	sso_header_session_roles => $sso_header_session_roles,
	sso_header_session_role_delimiter => $sso_header_session_role_delimiter,
	sso_header_session_attributes => $sso_header_session_attributes,
	sso_header_session_user_attribute_delimiter => $sso_header_session_user_attribute_delimiter, 
	hazelcast_cluster_nodes => $hazelcast_cluster_nodes
  }->
  class {'oi4portal::service':
  }->
  class {'tomcat':
    catalina_home       => "$oi_home/tomcat",
    install_from_source => false,
    manage_user         => false,
    manage_group        => false,
    user                => 'oiuser',
    group               => 'oiuser',
  }-> tomcat::config::server::listener {'identityContext':
    class_name   => "org.openinfinity.sso.security.context.grid.IdentityContext",
  }-> tomcat::config::server::valve { 'securityvault-valve':
    class_name    => 'org.openinfinity.sso.valve.AttributeBasedSecurityVaultValve',
  }
}
