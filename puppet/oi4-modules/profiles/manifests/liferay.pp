class profiles::liferay {
  $multicast_address = hiera('toas::portal:multicast_address')
  $db_address = hiera('toas::portal::db_address')
  $db_password = hiera('toas::portal::db_password')
  $tomcat_monitor_role_password = hiera('toas::portal::tomcat_monitor_role_password')
  $jvm_memory_opts = hiera('toas::portal::jvm_memory_opts', '-Xmx1024m')
  $extra_jvm_opts = hiera('toas::portal::extra_jvm_opts', undef)
  $extra_catalina_opts = hiera('toas::portal::extra_catalina_opts', undef)
  $oi_home = hiera('toas::oi_home', '/opt/openinfinity')

  file {"$oi_home/log/tomcat":
    ensure  => 'directory',
    owner   => 'oiuser',
    group   => 'oiuser',
    mode    => 755,
    require => [User["oiuser"], File["$oi_home/log"]],
  }->
  class {'oi4portal::install': 
  }->
  class {'oi4portal::config':
    portal_multicast_address            => $multicast_address,
    portal_db_address                   => $db_address,
    portal_db_password                  => $db_password,
    portal_tomcat_monitor_role_password => $tomcat_monitor_role_password,
    portal_extra_jvm_opts               => $extra_jvm_opts,
    portal_extra_catalina_opts          => $extra_catalina_opts,
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
  }
  tomcat::setenv::entry { 'jvm_memory_opts':
    param      => 'JVM_MEMORY_OPTS',
    value      => $jvm_memory_opts,
    quote_char => '"',
    order      => '1',
  }
  tomcat::setenv::entry { 'class_loader_opts':
    param      => 'CLASS_LOADER_OPTS',
    value      => '-Dorg.apache.catalina.loader.WebappClassLoader.ENABLE_CLEAR_REFERENCES=false',
    quote_char => '"',
    order      => '2',
  }
  tomcat::setenv::entry { 'jmx_opts':
    param      => 'JMX_OPTS',
    value      => "-Dcom.sun.management.jmxremote -Dcom.sun.management.jmxremote.port=65329 -Dcom.sun.management.jmxremote.ssl=false -Dcom.sun.management.jmxremote.authenticate=true -Dcom.sun.management.jmxremote.password.file=$oi_home/tomcat/conf/jmxremote.password -Dcom.sun.management.jmxremote.access.file=$oi_home/tomcat/conf/jmxremote.access",
    quote_char => '"',
    order      => '3',
  }
  tomcat::setenv::entry { 'sec_vault_opts':
    param      => 'SECURITY_VAULT_OPTS',
    value      => "-Dsecurity.vault.properties.file=$oi_home/tomcat/conf/securityvault.properties",
    quote_char => '"',
    order      => '4',
  }
  tomcat::setenv::entry { 'extra_java_opts':
    param      => 'EXTRA_JVM_OPTS',
    value      => $portal_extra_jvm_opts,
    quote_char => '"',
    order      => '5',
  }
  tomcat::setenv::entry { 'extra_catalina_opts':
    param      => 'EXTRA_CATALINA_OPTS',
    value      => $portal_extra_catalina_opts,
    quote_char => '"',
    order      => '6',
  }
  tomcat::setenv::entry { 'java_opts':
    param      => 'JAVA_OPTS',
    value      => '$JAVA_OPTS $CLASS_LOADER_OPTS $JMX_OPTS -Duser.timezone=EET -Dfile.encoding=UTF8 $JVM_MEMORY_OPTS $SECURITY_VAULT_OPTS $EXTRA_JVM_OPTS',
    quote_char => '"',
    order      => '7',
  }
  tomcat::setenv::entry { 'catalina_opts':
    param      => 'CATALINA_OPTS',
    value      => '$CATALINA_OPTS $EXTRA_CATALINA_OPS',
    quote_char => '"',
    order      => '8',
  }
  tomcat::setenv::entry { 'catalina_out':
    param      => 'CATALINA_OUT',
    value      => "$oi_home/log/tomcat/catalina.out",
    quote_char => '"',
  }
}
