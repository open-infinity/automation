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

class oi3mongos::install {
    package { ['mongodb-org-mongos', 'mongodb-org-shell']:
    }
}

class oi3mongos::config {
    # Directories to be created
    $mongo_directories = [
        "/opt/openinfinity",
        "/opt/openinfinity/log",
        "/opt/openinfinity/log/mongodb",
        "/opt/openinfinity/data",
        "/opt/openinfinity/data/mongos",
        "/opt/openinfinity/service",
        "/opt/openinfinity/service/mongodb",
        "/opt/openinfinity/service/mongodb/scripts",
    ]
    file { $mongo_directories:
        ensure => "directory",
        owner => 'mongod',
        group => 'mongod',
        mode => 0755,
    }

    file { '/etc/mongos.conf':
        ensure => present,
        notify => Service["mongos"],
        owner => "mongod",
        group => "mongod",
        content => template("oi3-oi3mongos/mongos.conf.erb"),
        require => Class["oi3mongos::install"],
    }
    
    file { '/etc/init.d/mongos':
        ensure => present,
        notify => Service["mongos"],
        owner => "root",
        group => "root",
        source => "puppet:///modules/oi3mongos/mongos",
        require => Class["oi3mongos::install"],
    }

    file { '/etc/sysconfig/mongos':
        ensure => present,
        notify => Service["mongos"],
        owner => "mongos",
        group => "mongos",
        content => template("oi3-oi3mongos/sysconfig-mongos"),
        require => Class["oi3mongos::install"],
    }
}

class oi3mongos::service {
    service { "mongos":
        ensure => running,
        hasrestart => true,
        enable => true,
        require => Class["oi3mongos::config"],
    }
}

