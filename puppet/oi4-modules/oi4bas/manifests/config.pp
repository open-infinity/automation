class oi4bas::config (
  $bas_multicast_address = undef,
  $bas_tomcat_monitor_role_pwd = undef,
  $oi_home = '/opt/openinfinity',
  $ignore_catalina_propeties = undef,
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

  file {"$oi_home/tomcat/conf/hazelcast.xml":
    ensure => present,
    owner => 'oiuser',
    group => 'oiuser',
    mode => 0600,
    content => template("oi4bas/hazelcast.xml.erb"),
    require => Class["oi4bas::install"],
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
    file {"/opt/data":
            ensure => directory,
            owner => 'root',
            group => 'root',
            mode => 777,
        }

    file {"/data":
            ensure => link,
            target => '/opt/data',
            force => true,
            require => File["/opt/data"],
        }

    file {"/opt/openinfinity":
            ensure => directory,
            owner => 'oiuser',
            group => 'oiuser',
            mode => 644,
            require => User["oiuser"],
    }

    file {"/opt/openinfinity/data":
            ensure => directory,
            owner => 'oiuser',
            group => 'oiuser',
            mode => 644,
            require => [User["oiuser"], File["/opt/openinfinity"]],
    }

    file {"/opt/openinfinity/log":
            ensure => directory,
            owner => 'oiuser',
            group => 'oiuser',
            mode => 644,
            require => [User["oiuser"], File["/opt/openinfinity"]],
    }

    file {"/opt/openinfinity/conf":
            ensure => directory,
            owner => 'oiuser',
            group => 'oiuser',
            mode => 644,
            require => [User["oiuser"], File["/opt/openinfinity"]],
    }

    file {"/opt/openinfinity/service":
            ensure => directory,
            owner => 'oiuser',
            group => 'oiuser',
            mode => 644,
            require => [User["oiuser"], File["/opt/openinfinity"]],
    }

    file {"/opt/openinfinity/conf":
            ensure => directory,
            owner => 'oiuser',
            group => 'oiuser',
            mode => 644,
            require => [User["oiuser"], File["/opt/openinfinity"]],
    }

    file {"/opt/openinfinity/common":
            ensure => directory,
            owner => 'oiuser',
            group => 'oiuser',
            mode => 644,
            require => [User["oiuser"], File["/opt/openinfinity"]],
    }

}


