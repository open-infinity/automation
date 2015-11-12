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
	catalina_home		=> "${oi_home}/tomcat",
  }
  file {"$oi_home/log/tomcat":
    ensure  => 'directory',
    owner   => 'oiuser',
    group   => 'oiuser',
    mode    => 755,
    require => [User["oiuser"], File["${oi_home}/log"]],
  }->
  class {'oi4bas::install':
  }->
  class {'oi4bas::config':
    bas_multicast_address       => $multicast_address,
    bas_tomcat_monitor_role_pwd => $tomcat_monitor_role_password,
  }->
  class {'oi4bas::service': }
  
  tomcat::config::server::valve { 'securityvault-valve':
    class_name    => 'org.openinfinity.sso.valve.AttributeBasedSecurityVaultValve',
  }
  tomcat::setenv::entry { 'catalina_out':
    param => 'CATALINA_OUT',
    value => "${oi_home}/log/tomcat/catalina.out",
  }
  tomcat::setenv::entry {'jmx_opts':
    param => 'JMX_OPTS',
    value => "\"-Dcom.sun.management.jmxremote -Dcom.sun.management.jmxremote.port=65329 -Dcom.sun.management.jmxremote.ssl=false -Dcom.sun.management.jmxremote.authenticate=true -Dcom.sun.management.jmxremote.password.file=$oi_home/tomcat/conf/jmxremote.password -Dcom.sun.management.jmxremote.access.file=$oi_home/tomcat/conf/jmxremote.access\"",
    order => 1,
  }
  tomcat::setenv::entry { 'extra_jvm_opts':
    param => 'EXTRA_JVM_OPTS',
    value => $extra_jvm_opts,
    order => 2,
  }
  tomcat::setenv::entry { 'extra_catalina_opts':
    param => 'EXTRA_CATALINA_OPTS',
    value => $extra_catalina_opts,
    order => 3,
  }
  tomcat::setenv::entry { 'java_opts':
    param => 'JAVA_OPTS',
    value => "\"$JAVA_OPTS -Dorg.apache.catalina.loader.WebappClassLoader.ENABLE_CLEAR_REFERENCES=false -Duser.timezone=EET -Dfile.encoding=UTF8 -Xmx${jvm_mem}m -XX:MaxPermSize=${jvm_perm}m -Dsecurity.vault.properties.file=$oi_home/tomcat/conf/securityvault.properties \$JMX_OPTS \$EXTRA_JVM_OPTS\"",
    order => 10,
  }
  tomcat::setenv::entry { 'catalina_opts':
    param => 'CATALINA_OPTS',
    value => '$CATALINA_OPTS $JMX_OPTS $EXTRA_CATALINA_OPTS',
    order => 11,
  }

}
