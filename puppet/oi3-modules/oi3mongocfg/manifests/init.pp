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

class oi3mongocfg::install {
    package { ['mongodb-org-server', 'mongodb-org-shell']:
    }
}

class oi3mongocfg::config {
    # Directories to be created
    $mongo_directories = [
        "/opt/openinfinity",
        "/opt/openinfinity/log",
        "/opt/openinfinity/log/mongodb",
        "/opt/openinfinity/data",
        "/opt/openinfinity/data/mongocfg",
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

    file { '/etc/mongocfg.conf':
        ensure => present,
        notify => Service["mongocfg"],
        owner => "mongod",
        group => "mongod",
        content => template("oi3-oi3mongocfg/mongocfg.conf.erb"),
        require => Class["oi3mongocfg::install"],
    }
    
    file { '/etc/init.d/mongocfg':
        ensure => present,
        notify => Service["mongocfg"],
        owner => "root",
        group => "root",
        source => "puppet:///modules/oi3mongocfg/mongocfg",
        require => Class["oi3mongocfg::install"],
    }

    file { '/etc/sysconfig/mongocfg':
        ensure => present,
        notify => Service["mongocfg"],
        owner => "mongod",
        group => "mongod",
        content => template("oi3-oi3mongocfg/sysconfig-mongocfg"),
        require => Class["oi3mongocfg::install"],
    }
    
}

class oi3mongocfg::service {
    service { "mongocfg":
        ensure => running,
        hasrestart => true,
        enable => true,
        require => Class["oi3mongocfg::config"],
    }
}

