#
# MongoDB Configuration Server
#
# See our Confluence for more information about the parameters.
#

class oi3mongocfg {
    require oi3mongocfg::install
    require oi3mongocfg::config
    require oi3mongocfg::service
}

class oi3mongocfg::install inherits oi3mongocommon {
}

class oi3mongocfg::config {
    # Directories to be created
    $mongo_directories = [
        "/opt/openinfinity/data/mongocfg",
    ]
    file { $mongo_directories:
        ensure => "directory",
        owner => 'mongod',
        group => 'mongod',
        mode => 0755,
        require => Class["oi3mongocfg::install"],
     }

    file { '/etc/mongocfg.conf':
        ensure => present,
        notify => Service["mongocfg"],
        owner => "mongod",
        group => "mongod",
        content => template("oi3mongocfg/mongocfg.conf.erb"),
        require => Class["oi3mongocfg::install"],
    }
    
    file { '/etc/init.d/mongocfg':
        ensure => present,
        notify => Service["mongocfg"],
        owner => "root",
        group => "root",
        mode => 0755,
        source => "puppet:///modules/oi3mongocfg/mongocfg",
        require => Class["oi3mongocfg::install"],
    }

    file { '/etc/sysconfig/mongocfg':
        ensure => present,
        notify => Service["mongocfg"],
        owner => "mongod",
        group => "mongod",
        source => "puppet:///modules/oi3mongocfg/sysconfig-mongocfg",
        require => Class["oi3mongocfg::install"],
    }
    
}

class oi3mongocfg::service {
    service { "mongocfg":
        ensure => running,
        enable => true,
        hasrestart => true,
        subscribe => [
            Package['mongodb-org-server'],
            File["/opt/openinfinity/log/mongodb"],
            File["/opt/openinfinity/data/mongocfg"],
            File["/etc/mongocfg.conf"],
            File["/etc/init.d/mongocfg"],
            File["/etc/sysconfig/mongocfg"],
        ],
    }
}

