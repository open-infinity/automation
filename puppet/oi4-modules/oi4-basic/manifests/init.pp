class oi4-basic::config ($toaspathversion = undef) {

  if $toaspathversion == undef {
    $_toasversion = $::toaspathversion
  } else {
    $_toasversion = $toaspathversion
  }
  #if $_toasversion == undef {
  #	fail("Missing _toasversion (toaspathversion) variable")
  #}

   /* require oi4-ebs
        file {"/etc/logrotate.d/oi-tomcat":
        ensure => present,
        content => template("oi4-basic/oi-tomcat.logrotate.erb"),
        owner => "root",
        group => "root",
        mode => 0644,
    }*/

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

    file {"/opt/openinfinity/$_toasversion":
            ensure => directory,
            owner => 'oiuser',
            group => 'oiuser',
            mode => 644,
            require => [User["oiuser"], File["/opt/openinfinity"]],
    }

    file {"/home/oiuser":
            ensure => directory,
            owner => 'oiuser',
            group => 'oiuser',
            mode => 750,
            require => [User['oiuser'],Group['oiuser']]
    }

    user { "oiuser":
            ensure => present,
            comment => "Open Infinity user",
            gid => "oiuser",
            shell => "/bin/bash",
            managehome => true,
            require => Group["oiuser"],
        }

    group {"oiuser":
            ensure => present,
        }
}

class oi4-basic::service inherits oi4variables {
    service { $cronServiceName:
        ensure => running,
        hasstatus => true,
        hasrestart => true,
        enable => true,
        require => Class["oi4-basic::install"],
    }
}

class oi4-basic::install inherits oi4variables {
    package { $cronPackageName:
        ensure => installed,
        require => Class["oi4-basic::config"],
    }
}

class oi4-basic {
    /*require oi4-ebs*/
    include  oi4-basic::install, oi4-basic::config,  oi4-basic::service
}

