#
# MongoDB Database Node
#
# See our Confluence for more information about the parameters.
#
class oi4mongod (
	$mongo_cluster_type = undef, 
	$mongod_port = undef,
	$mongo_storage_smallFiles = undef,
	$mongo_security_authorization = undef,
	$mongod_replicaset_name = undef,
	$mongod_replicaset_oplogSizeMB =undef,
	$mongod_replicaset_node = undef,
	$mongo_mongos_node = undef
) 
{	
	class {'oi4mongod::config':
	}
    case $mongo_cluster_type {
        replicaset: { 
            class {'oi4mongod::replicaset':
				mongod_replicaset_node => $mongod_replicaset_node,
				mongod_replicaset_name => $mongod_replicaset_name,
				mongod_port => $mongod_replicaset_name, 
				require => Class["oi4mongod::config"]
			}->class{'oi4mongod::service':} 
        }
        sharded: { 
            class {'oi4mongod::replicaset':
				mongod_replicaset_node => $mongod_replicaset_node,
				mongod_replicaset_name => $mongod_replicaset_name,
				mongod_port => $mongod_replicaset_name, 
				require => Class["oi4mongod::config"]
			}-> class {'oi4mongod::shards':
				mongod_replicaset_name => $mongod_replicaset_name,
				mongod_replicaset_node => $mongod_replicaset_node, 
				mongo_mongos_node => $mongo_mongos_node,
				mongod_port => $mongod_port
			} ->class{'oi4mongod::service':}
        }
    }
	
	
}


class oi4mongod::config (
	$mongo_storage_smallFiles = undef, 
	$mongo_security_authorization = undef, 
	$mongod_port = undef,
	$mongod_replicaset_name = undef,
	$mongod_replicaset_oplogSizeMB = undef, 
	$mongo_cluster_type = undef
)
{
	#
	# Typical puppet stuff
	#

    # Directories to be created
	
    $mongo_directories = [
        "/opt/openinfinity/data/mongod",
    ]
	user { "mongod":
            ensure => present,
            comment => "Open Infinity user",
            gid => "mongod",
            shell => "/bin/bash",
            managehome => true,
            require => Group["mongod"],
    }
	group {"mongod":
            ensure => present,
    }
	
    file { $mongo_directories:
        ensure => "directory",
        owner => 'mongod',
        group => 'mongod',
        mode => 0755,
    }

    file { '/etc/mongod.conf':
        ensure => present,
        owner => "mongod",
        group => "mongod",
        content => template("oi4mongod/mongod.conf.erb"),
    }
    
    file { '/etc/init.d/mongod':
        ensure => present,
        owner => "root",
        group => "root",
        mode => 0755,
        source => "puppet:///modules/oi4mongod/mongod",
    }

    file { '/etc/sysconfig/mongod':
        ensure => present,
        owner => "mongod",
        group => "mongod",
        source => "puppet:///modules/oi4mongod/sysconfig-mongod",
    }

}

class oi4mongod::service {
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

class oi4mongod::replicaset (
	$mongod_replicaset_node = undef,
	$mongod_replicaset_name = undef,
	$mongod_port = undef
)

{
    file { '/opt/openinfinity/service/mongodb/scripts/rset-join.sh':
        ensure => present,
        owner => "mongod",
        group => "mongod",
        mode => 0755,
        content => template("oi4mongod/rset-join.sh.erb"),
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

class oi4mongod::shards (
	$mongod_replicaset_name = undef,
	$mongod_replicaset_node = undef, 
	$mongo_mongos_node = undef,
	$mongod_port = undef

)
 {
    file { '/opt/openinfinity/service/mongodb/scripts/shard-join.sh':
        ensure => present,
        owner => "mongod",
        group => "mongod",
        mode => 0755,
        content => template("oi4mongod/shard-join.sh.erb"),
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





