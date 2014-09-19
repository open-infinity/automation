#
# MongoDB Database Node
#
# expected parameters:
#
#   mongo_cluster_type: <'standalone' | 'replicaset' | 'sharded'>
#       at moment only replicaset is supported
#
#   mongo_replicaset_name: <name>
#       a unique name for the replica set
#
#   mongod_replicaset_node: <host:port> 
#       initial primary node, but later any node in the replica set
#
#   mongod_port: <port>
#       typically 27018 for sharded cluster and 27017 for the others
#
#   mongo_storage_smallFiles: <'true' | 'false'>
#       true saves initial disk space but decreases performance
#
#   mongo_security_authorization: <'enabled' | 'disabled'>
#       enabling auth requires manual configuration at moment
#
#   mongo_replicaset_oplogSizeMB: <'default' | size-in-mega-bytes>
#       http://docs.mongodb.org/manual/core/replica-set-oplog/
#
# Either DNS or /etc/hosts based name resolution is expected to work.
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

