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

class oi3mongod::install inherits oi3mongocommon {
}

class oi3mongod::config {
    # Directories to be created
    $mongo_directories = [
        "/opt/openinfinity/data/mongod",
    ]
    file { $mongo_directories:
        ensure => "directory",
        owner => 'mongod',
        group => 'mongod',
        mode => 0755,
        require => Class["oi3mongod::install"],
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
        source => "puppet:///modules/oi3mongod/sysconfig-mongod",
        require => Class["oi3mongod::install"],
    }

}

class oi3mongod::service {
    service { "mongod":
        ensure => running,
        enable => true,
        hasrestart => true,
        subscribe => [
            Package['mongodb-org-server'],
            File["/opt/openinfinity/log/mongodb"],
            File["/opt/openinfinity/data/mongod"],
            File["/etc/mongod.conf"],
            File["/etc/init.d/mongod"],
            File["/etc/sysconfig/mongod"],
        ],
    }
}

class oi3mongod::replicaset {
    file { '/opt/openinfinity/service/mongodb/scripts/rset-join.sh':
        ensure => present,
        owner => "mongod",
        group => "mongod",
        mode => 0755,
        content => template("oi3mongod/rset-join.sh.erb"),
        require => Service['mongod'],
    }
    
    # Execute the replica set join script.
    exec { 'rset-join':
        command => "/opt/openinfinity/service/mongodb/scripts/rset-join.sh",
        #tries => 2,
        #try_sleep => 60,
        logoutput => true,
        user => "mongod",
        require => File['/opt/openinfinity/service/mongodb/scripts/rset-join.sh'],
    }
}

class oi3mongod::shard {
    file { '/opt/openinfinity/service/mongodb/scripts/shard-join.sh':
        ensure => present,
        owner => "mongod",
        group => "mongod",
        mode => 0755,
        content => template("oi3mongod/shard-join.sh.erb"),
        require => Exec['rset-join'],
    }

    # Execute the shard join script.
    exec { 'shard-join':
        command => "/opt/openinfinity/service/mongodb/scripts/shard-join.sh",
        tries => 3,
        try_sleep => 60,
        user => "mongod",
        logoutput => true,
        require => [
            File['/opt/openinfinity/service/mongodb/scripts/shard-join.sh'], 
            Exec['rset-join']
        ],
    }
}

