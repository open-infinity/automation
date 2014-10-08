#
# MongoDB Routing Process
#
# See our Confluence for more information about the parameters.
#

class oi3mongos {
    require oi3mongos::install
    require oi3mongos::config
    require oi3mongos::service
}

class oi3mongos::install inherits oi3mongocommon {
}

class oi3mongos::config {
    file { '/etc/mongos.conf':
        ensure => present,
        notify => Service["mongos"],
        owner => "mongod",
        group => "mongod",
        content => template("oi3mongos/mongos.conf.erb"),
        require => Class["oi3mongos::install"],
    }
    
    file { '/etc/init.d/mongos':
        ensure => present,
        notify => Service["mongos"],
        owner => "root",
        group => "root",
        mode => 0755,
        source => "puppet:///modules/oi3mongos/mongos",
        require => Class["oi3mongos::install"],
    }

    file { '/etc/sysconfig/mongos':
        ensure => present,
        notify => Service["mongos"],
        owner => "mongod",
        group => "mongod",
        source => "puppet:///modules/oi3mongos/sysconfig-mongos",
        require => Class["oi3mongos::install"],
    }
}

class oi3mongos::service {
    service { "mongos":
        ensure => running,
        enable => true,
        hasrestart => true,
        subscribe => [
            Package['mongodb-org-mongos'],
            File["/opt/openinfinity/log/mongodb"],
            File["/etc/mongos.conf"],
            File["/etc/init.d/mongos"],
            File["/etc/sysconfig/mongos"],
        ],
    }
}

