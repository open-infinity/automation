#
# MongoDB Database Node
#
# See our Confluence for more information about the parameters.
#

class oi3mongod {
    require oi3mongod::install
    require oi3mongod::config
    require oi3mongod::service
    case $mongo_cluster_type {
        replicaset: { 
            require oi3mongod::replicaset
        }
        sharded: { 
            require oi3mongod::replicaset
            require oi3mongod::shard 
        }
    }
}

class oi3mongod::install {
    package { ['mongodb-org-server', 'mongodb-org-shell']:
    }
}

class oi3mongod::config {
    # Directories to be created
    $mongo_directories = [
        "/opt/openinfinity",
        "/opt/openinfinity/log",
        "/opt/openinfinity/log/mongodb",
        "/opt/openinfinity/data",
        "/opt/openinfinity/data/mongod",
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

    file { '/etc/mongod.conf':
        ensure => present,
        notify => Service["mongod"],
        owner => "mongod",
        group => "mongod",
        content => template("oi3mongod/mongod.conf.erb"),
        require => Class["oi3mongod::install"],
    }
    
    file { '/etc/init.d/mongod':
        ensure => present,
        notify => Service["mongod"],
        owner => "root",
        group => "root",
        mode => 0755,
        source => "puppet:///modules/oi3mongod/mongod",
        require => Class["oi3mongod::install"],
    }

    file { '/etc/sysconfig/mongod':
        ensure => present,
        notify => Service["mongod"],
        owner => "mongod",
        group => "mongod",
        content => template("oi3-oi3mongod/sysconfig-mongod"),
        require => Class["oi3mongod::install"],
    }

}

class oi3mongod::service {
    service { "mongod":
        ensure => running,
        hasrestart => true,
        enable => true,
        require => Class["oi3mongod::config"],
    }
}

class oi3mongod::replicaset {
    file { '/opt/openinfinity/service/mongodb/scripts/rset-join.sh':
        ensure => present,
        owner => "mongod",
        group => "mongod",
        mode => 0755,
        content => template("oi3mongod/rset-join.sh.erb"),
        require => Class["oi3mongod::service"],
    }
    
    # Execute the replica set join script.
    exec { 'rset-join':
        command => "/opt/openinfinity/service/mongodb/scripts/rset-join.sh",
        #tries => 2,
        #try_sleep => 60,
        user => "mongod",
        require => File['/opt/openinfinity/service/mongodb/scripts/rset-join.sh'],
    }
}

class oi3mongod::shard {
    file { '/opt/openinfinity/service/mongodb/scripts/shard-join.sh':
        ensure => present,
        owner => "mongod",
        group => "mongod",
        content => template("oi3mongod/shard-join.sh.erb"),
        require => Class["oi3mongod::service"],
    }

    # Execute the shard join script.
    exec { 'shard-join':
        command => "/opt/openinfinity/service/mongodb/scripts/shard-join.sh",
        tries => 3,
        try_sleep => 60,
        user => "mongod",
        require => [
            File['/opt/openinfinity/service/mongodb/scripts/shard-join.sh'], 
            Exec['rset-join']
        ],
    }
}

#class oi3mongod::foo {
#}

