class oi3-portal::install ($toaspathversion = undef) {

  if $toaspathversion == undef {
    $_toaspathversion = $::toaspathversion
  }
  else {
    $_toaspathversion = $toaspathversion
  }

	package { ["java-1.7.0-openjdk", "oi3-connectorj", "oi3-liferay", "oi3-core", "oi3-tomcat", "oi3-secvault", "oi3-hazelcast"]:
		ensure => present,
		require => Class["oi3-basic"],
	}
#	package { ["oi3-bas"]:


	file {"/opt/openinfinity/$_toaspathversion/deploy":
                ensure => directory,
                owner => 'oiuser',
                group => 'oiuser',
                mode => 0755,
                require => Class["oi3-basic"],
        }

#	package { ["oi-theme-2.0.0-1"]:
#		ensure => present,
#		require => File["/opt/openinfinity/2.0.0/deploy"],
#	}

	file {"/opt/openinfinity/$_toaspathversion/data":
		ensure => directory,
		owner => 'oiuser',
		group => 'oiuser',
		mode => 0755,
		require => Class["oi3-basic"],
	}
}

class oi3-portal::config (
  $toaspathversion = undef,
  $portal_multicast_address = undef,
  $portal_db_address = undef,
  $portal_db_password = undef,
  $portal_tomcat_monitor_role_password = undef,
  $portal_jvmmem = undef,
  $portal_jvmperm = undef,
  $portal_extra_jvm_opts = undef,
  $portal_extra_catalina_opts = undef
)

{
  if $toaspathversion == undef {
    $_toaspathversion = $::toaspathversion
  }
  else {
    $_toaspathversion = $toaspathversion
  }
  if $portal_multicast_address == undef {
    $_portal_multicast_address = $::multicastaddress
  }
  else {
    $_portal_multicast_address = $portal_multicast_address
  }
  if $portal_db_address == undef {
    $_portal_db_address = $::dbaddress
  }
  else {
    $_portal_db_address = $portal_db_address
  }
  if $portal_db_password == undef {
    $_portal_db_password = $::liferay_db_password
  }
  else {
    $_portal_db_password = $portal_db_password
  }
  if $portal_tomcat_monitor_role_password == undef {
    $_portal_tomcat_monitor_role_password = $::tomcat_monitor_role_pwd
  }
  else {
    $_portal_tomcat_monitor_role_password = $portal_tomcat_monitor_role_password
  }
  if $portal_jvmmem == undef {
    $_portal_jvmmem = $::jvmmem
  }
  else {
    $_portal_jvmmem = $portal_jvmmem
  }
  if $portal_jvmperm == undef {
    $_portal_jvmperm = $::jvmperm
  }
  else {
    $_portal_jvmperm = $portal_jvmperm
  }
  if $portal_extra_jvm_opts == undef {
    $_portal_extra_jvm_opts = $::extra_jvm_opts
  }
  else {
    $_portal_extra_jvm_opts = $portal_extra_jvm_opts
  }
  if $portal_extra_catalina_opts == undef {
    $_portal_extra_catalina_opts = $::extra_catalina_opts
  }
  else {
    $_portal_extra_catalina_opts = $portal_extra_catalina_opts
  }

	exec {"set-privileges":
		command => "/bin/chown -R oiuser:oiuser /opt/openinfinity/$_toaspathversion",
		require => Class["oi3-portal::install"],
	}

	file {"/opt/openinfinity/$_toaspathversion/tomcat/webapps/ROOT/WEB-INF/classes/portal-ext.properties":
		ensure => present,
		owner => 'oiuser',
		group => 'oiuser',
		mode => 0644,
		content => template("oi3-portal/portal-ext.properties.erb"),
		require => Class["oi3-portal::install"],
		notify => Service["oi-tomcat"],
	}

	file {"/opt/openinfinity/$_toaspathversion/tomcat/conf/catalina.properties":
                ensure => present,
                owner => 'oiuser',
                group => 'oiuser',
                mode => 0600,
                source => "puppet:///modules/oi3-portal/catalina.properties",
                require => Class["oi3-portal::install"],
        }

	file {"/opt/openinfinity/$_toaspathversion/tomcat/bin/setenv.sh":
                ensure => present,
                owner => 'oiuser',
                group => 'oiuser',
                mode => 0755,
                content => template("oi3-portal/setenv.sh.erb"),
                require => Class["oi3-portal::install"],
        }

	file {"/opt/openinfinity/$_toaspathversion/tomcat/conf/Catalina/localhost/ROOT.xml":
		ensure => present,
		owner => 'oiuser',
		group => 'oiuser',
		mode => 0600,
		source => "puppet:///modules/oi3-portal/ROOT.xml",
		require => File["/opt/openinfinity/$_toaspathversion/tomcat/conf/Catalina/localhost"],
	}

	file {"/opt/openinfinity/$_toaspathversion/tomcat/conf/Catalina/localhost":
                ensure => directory,
                owner => 'oiuser',
                group => 'oiuser',
                mode => 0755,
                require => File["/opt/openinfinity/$_toaspathversion/tomcat/conf/Catalina"],
        }

	file {"/opt/openinfinity/$_toaspathversion/tomcat/conf/Catalina":
                ensure => directory,
                owner => 'oiuser',
                group => 'oiuser',
                mode => 0755,
                require => Class["oi3-portal::install"],
        }

        file {"/opt/openinfinity/$_toaspathversion/tomcat/conf/server.xml":
                ensure => present,
                owner => 'oiuser',
                group => 'oiuser',
                mode => 0600,
                source => "puppet:///modules/oi3-portal/server.xml",
                require => Class["oi3-portal::install"],
        }

	# Security Vault configuration
	file {"/opt/openinfinity/$_toaspathversion/tomcat/conf/securityvault.properties":
		ensure    => present,
		owner     => 'oiuser',
		group     => 'oiuser',
		mode      => 0600,
    content => template("oi3-portal/securityvault.properties.erb"),
		require   => Class["oi3-portal::install"],
	}

	file {"/opt/openinfinity/$_toaspathversion/tomcat/conf/hazelcast.xml":
		ensure => present,
		owner => 'oiuser',
		group => 'oiuser',
		mode => 0600,
		content => template("oi3-portal/hazelcast.xml.erb"),
		require => Class["oi3-portal::install"],
	}
	
        file {"/opt/openinfinity/$_toaspathversion/tomcat/conf/context.xml":
                ensure => present,
                owner => 'oiuser',
                group => 'oiuser',
                mode => 0600,
                source => "puppet:///modules/oi3-portal/context.xml",
                require => Class["oi3-portal::install"],
        }

        file {"/opt/openinfinity/$_toaspathversion/tomcat/conf/jmxremote.password":
                ensure => present,
                owner => 'oiuser',
                group => 'oiuser',
                mode => 0600,
                content => template("oi3-portal/jmxremote.password.erb"),
                require => Class["oi3-portal::install"],
        }

        file {"/opt/openinfinity/$_toaspathversion/tomcat/conf/jmxremote.access":
                ensure => present,
                owner => 'oiuser',
                group => 'oiuser',
                mode => 0644,
                source => "puppet:///modules/oi3-portal/jmxremote.access",
                require => Class["oi3-portal::install"],
        }

        file {"/etc/init.d/oi-tomcat":
                ensure  => present,
                owner   => 'root',
                group   => 'root',
                mode    => 0755,
                content => template("oi3-portal/oi-tomcat.erb"),
                require => Class["oi3-portal::install"],
        }
	
	file {"/opt/openinfinity/$_toaspathversion/portal-setup-wizard.properties":
		ensure    => present,
		owner     => 'oiuser',
		group     => 'oiuser',
		mode      => 0644,
    content => template("oi3-portal/portal-setup-wizard.properties.erb"),
		require   => Class["oi3-portal::install"],
	}
#  file { "/opt/openinfinity/3.1.0/oi-core-libs/deps/ehcache-core-2.6.6.jar":
#    ensure  => absent,
#                require => Class["oi3-portal::install"],
#  }
}

class oi3-portal::service {
	service {"oi-tomcat":
		ensure => running,
		hasrestart => true,
		enable => true,
		require => Class["oi3-portal::config"],
	}
}

class oi3-portal {
	require oi3-ebs
	require oi3-basic
	include oi3-portal::install
	include oi3-portal::config
	include oi3-portal::service
}

