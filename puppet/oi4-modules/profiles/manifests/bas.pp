class profiles::bas {
  $multicast_address = hiera('toas::bas:multicast_address')
  $tomcat_monitor_role_password = hiera('toas::bas::tomcat_monitor_role_password')
  $extra_jvm_opts = hiera('toas::bas::extra_jvm_opts', undef)
  $extra_catalina_opts = hiera('toas::bas::extra_catalina_opts', undef)
  $jvm_mem = hiera('toas::bas::jvm_mem')
  $jvm_perm = hiera('toas::bas:jvm_perm')
  $oi_home = hiera('toas::oi_home', '/opt/openinfinity')

  class { 'tomcat':
    install_from_source => false,
    user                => 'oiuser',
    group               => 'oiuser',
    manage_user         => false,
    manage_group        => false,
  }

  class {'oi4bas::install':
  }->
  class {'oi4bas::config':
    bas_multicast_address       => $multicast_address,
    bas_tomcat_monitor_role_pwd => $tomcat_monitor_role_password,
    bas_jvmmem                  => $jvm_mem,
    bas_jvmperm                 => $jvm_perm,
    bas_extra_jvm_opts          => $extra_jvm_opts,
    bas_extra_catalina_opts     => $extra_catalina_opts,
  }->
  tomcat::config::server::valve { 'securityvault-valve':
    class_name    => 'org.openinfinity.sso.valve.AttributeBasedSecurityVaultValve',
    catalina_base => "$oi_home/tomcat",
  }->
  class {'oi4bas::service':
  }

}
