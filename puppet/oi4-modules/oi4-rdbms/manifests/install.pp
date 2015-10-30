class oi3-rdbms::install ($toaspathversion = undef) {

  if $toaspathversion == undef {
    $_toaspathversion = $::toaspathversion
  }
  else {
    $_toaspathversion = $toaspathversion
  }

    file {"/opt/openinfinity/$_toaspathversion/rdbms":
        ensure => directory,
        owner => "mysql",
        group => "mysql",
        mode => 0775,
        require => File["/opt/openinfinity/$_toaspathversion"],
    }

#   file {"/opt/openinfinity/3.1.0/rdbms/etc":
#                ensure => directory,
#                owner => "mysql",
#                group => "mysql",
#                mode => 0775,
#                require => file["/opt/openinfinity/3.1.0/rdbms"],
#        }

    file {"/opt/openinfinity/$_toaspathversion/rdbms/data":
        ensure => directory,
        owner => "mysql",
        group => "mysql",
        mode => 0775,
        require => File["/opt/openinfinity/$_toaspathversion/rdbms"],
    }

    package { "oi3-rdbms":
        ensure => present,
        require => File["/opt/openinfinity/$_toaspathversion/rdbms/data"],
    }

    user { "mysql":
        ensure => present,
        comment => "MariaDB user",
        gid => "mysql",
        shell => "/bin/false",
        require => Group["mysql"],
    }

    group { "mysql":
        ensure => present,
    }
}
