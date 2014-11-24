class oi3-bas::config (
  $bas_multicast_address = undef,
  $bas_tomcat_monitor_role_pwd = undef,
  $bas_tomcat_connector_attributes = undef,
  $bas_tomcat_ajp_connector_attributes = undef,
  $bas_jvmmem = undef,
  $bas_jvmperm = undef,
  $bas_extra_jvm_opts = undef,
  $bas_extra_catalina_opts = undef,
  $toaspathversion = undef
) inherits oi3variables

{
  if $toaspathversion == undef {
    $_toasversion = $::toaspathversion
  }
  else {
    $_toasversion = $toaspathversion
  }
  if $bas_multicast_address == undef {
    $_bas_multicast_address = $::multicastaddress
  }
  else {
    $_bas_multicast_address = $bas_multicast_address
  }
  if $bas_tomcat_monitor_role_pwd == undef {
    $_bas_tomcat_monitor_role_pwd = $::tomcat_monitor_role_pwd
  }
  else {
    $_bas_tomcat_monitor_role_pwd = $bas_tomcat_monitor_role_pwd
  }
  if $bas_tomcat_connector_attributes == undef {
    $_bas_tomcat_connector_attributes = $::tomcat_connector_attributes
  }
  else {
    $_bas_tomcat_connector_attributes = $bas_tomcat_connector_attributes
  }
  if $bas_tomcat_ajp_connector_attributes == undef {
    $_bas_tomcat_ajp_connector_attributes = $::ajp_connector_attributes
  }
  else {
    $_bas_tomcat_ajp_connector_attributes = $bas_tomcat_ajp_connector_attributes
  }
  if $bas_jvmmem == undef {
    $_bas_jvmmem = $::jvmmem
  }
  else {
    $_bas_jvmmem = $bas_jvmmem
  }
  if $bas_jvmperm == undef {
    $_bas_jvmperm = $::jvmperm
  }
  else {
    $_bas_jvmperm = $bas_jvmperm
  }
  if $bas_extra_jvm_opts == undef {
    $_bas_extra_jvm_opts = $::extra_jvm_opts
  }
  else {
    $_bas_extra_jvm_opts = $bas_extra_jvm_opts
  }
  if $bas_extra_catalina_opts == undef {
    $_bas_extra_catalina_opts = $::extra_catalina_opts
  }
  else {
    $_bas_extra_catalina_opts = $bas_extra_catalina_opts
  }

    file { "/opt/openinfinity/$_toasversion/tomcat/bin/setenv.sh":
        ensure => present,
        owner => 'oiuser',
        group => 'oiuser',
        mode => 0755,
        content => template("oi3-bas/setenv.sh.erb"),
        require => Class["oi3-bas::install"],
        notify => Service["oi-tomcat"],
    }

    file {"/opt/openinfinity/$_toasversion/tomcat/conf/catalina.properties":
        ensure => present,
        owner => 'oiuser',
        group => 'oiuser',
        mode => 0600,
        source => "puppet:///modules/oi3-bas/catalina.properties",
        require => Class["oi3-bas::install"],
        notify => Service["oi-tomcat"],
    }

    file {"/opt/openinfinity/$_toasversion/tomcat/conf/logging.properties":
	ensure => present,
	owner => 'oiuser',
	group => 'oiuser',
	mode => 0644,
	source => "puppet:///modules/oi3-bas/logging.properties",
	require => Class["oi3-bas::install"],
	notify => Service["oi-tomcat"],
    }

    file {"/opt/openinfinity/$_toasversion/tomcat/conf/server.xml":
        ensure => present,
        owner => 'oiuser',
        group => 'oiuser',
        mode => 0600,
        #source => "puppet:///modules/oi3-bas/server.xml",
        content => template("oi3-bas/server.xml.erb"),
        require => Class["oi3-bas::install"],
    }

    # Security Vault configuration
    file {"/opt/openinfinity/$_toasversion/tomcat/conf/securityvault.properties":
        ensure => present,
        owner => 'oiuser',
        group => 'oiuser',
        mode => 0600,
        content => template("oi3-bas/securityvault.properties.erb"),
        require => Class["oi3-bas::install"],
    }

    file {"/opt/openinfinity/$_toasversion/tomcat/conf/context.xml.openinfinity_example":
        ensure => present,
        owner => 'oiuser',
        group => 'oiuser',
        mode => 0600,
        source => "puppet:///modules/oi3-bas/context.xml",
        require => Class["oi3-bas::install"],
    }

    file {"/opt/openinfinity/$_toasversion/tomcat/conf/hazelcast.xml":
        ensure => present,
        owner => 'oiuser',
        group => 'oiuser',
        mode => 0600,
        content => template("oi3-bas/hazelcast.xml.erb"),
        require => Class["oi3-bas::install"],
    }

    file {"/etc/init.d/oi-tomcat":
        ensure => present,
        owner => 'root',
        group => 'root',
        mode => 0755,
        #source => "puppet:///modules/oi3-bas/oi-tomcat",
        content => template("oi3-bas/oi-tomcat.erb"),
        require => Class["oi3-bas::install"],
    }

    file {"/opt/openinfinity/$_toasversion/tomcat/conf/jmxremote.password":
        ensure => present,
        owner => 'oiuser',
        group => 'oiuser',
        mode => 0600,
        content => template("oi3-bas/jmxremote.password.erb"),
        require => Class["oi3-bas::install"],
    }

    file {"/opt/openinfinity/$_toasversion/tomcat/conf/jmxremote.access":
        ensure => present,
        owner => 'oiuser',
        group => 'oiuser',
        mode => 0644,
        source => "puppet:///modules/oi3-bas/jmxremote.access",
        require => Class["oi3-bas::install"],
    }


    # Try ensure, that the supported Java is chosen
    exec { "choose-java":
        path => "/",
        command => "${alternativesPath} --install /usr/bin/java java ${javaHome}/bin/java 190000",
        unless => "${alternativesPath} --display java | /bin/grep 'link currently points to ${javaHome}/bin/java'",
        require => Package[$javaPackageName],
    }
}


