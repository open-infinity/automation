#
# MongoDB Configuration Server
#
# See our Confluence for more information about the parameters.
#

class oi4mongocfg {
    include oi4mongocfg::config
    include oi4mongocfg::service
}

class oi4mongocfg::config 
(
	$mongo_storage_smallFiles = undef, 
	$mongo_security_authorization = undef,
	$mongocfg_port = undef, 
	$mongo_cluster_type = undef
)

 {
    # Directories to be created
    $mongo_directories = [
        "/opt/openinfinity/data/mongocfg",
    ]
    file { $mongo_directories:
        ensure => "directory",
        owner => 'mongod',
        group => 'mongod',
        mode => 0755,
     }

    file { '/etc/mongocfg.conf':
        ensure => present,
        owner => "mongod",
        group => "mongod",
        content => template("oi4mongocfg/mongocfg.conf.erb"),
    }
    
    file { '/etc/init.d/mongocfg':
        ensure => present,
        owner => "root",
        group => "root",
        mode => 0755,
        source => "puppet:///modules/oi4mongocfg/mongocfg",
    }

    file { '/etc/sysconfig/mongocfg':
        ensure => present,
        notify => Service["mongocfg"],
        owner => "mongod",
        group => "mongod",
        source => "puppet:///modules/oi4mongocfg/sysconfig-mongocfg",
    }
    
}

class oi4mongocfg::service {
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


