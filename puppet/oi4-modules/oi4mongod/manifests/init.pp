#
# MongoDB Database Node
#
# See our Confluence for more information about the parameters.
#

class oi4mongod {
	require oi4bas
    require oi4mongod::install
    require oi4mongod::config
    require oi4mongod::service
    case $mongo_cluster_type {
        replicaset: { 
            require oi4mongod::replicaset
        }
        sharded: { 
            require oi4mongod::replicaset
            require oi4mongod::shard 
        }
    }
}

class oi4mongod::install inherits oi4mongocommon {
}

class oi4mongod::config inherits oi4mongod::parameters {
	#
	# Typical puppet stuff
	#

    # Directories to be created
    $mongo_directories = [
        "/opt/openinfinity/data/mongod",
    ]
    file { $mongo_directories:
        ensure => "directory",
        owner => 'mongod',
        group => 'mongod',
        mode => 0755,
        require => Class["oi4mongod::install"],
    }

    file { '/etc/mongod.conf':
        ensure => present,
        notify => Service["mongod"],
        owner => "oiuser",
        group => "oiuser",
        content => template("oi4mongod/mongod.conf.erb"),
        require => Class["oi4mongod::install"],
    }
    
    file { '/etc/init.d/mongod':
        ensure => present,
        notify => Service["mongod"],
        owner => "root",
        group => "root",
        mode => 0755,
        source => "puppet:///modules/oi4mongod/mongod",
        require => Class["oi4mongod::install"],
    }

    file { '/etc/sysconfig/mongod':
        ensure => present,
        notify => Service["mongod"],
        owner => "mongod",
        group => "mongod",
        source => "puppet:///modules/oi4mongod/sysconfig-mongod",
        require => Class["oi4mongod::install"],
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

class oi4mongod::replicaset inherits oi4mongod::parameters {
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

class oi4mongod::shard inherits oi4mongod::parameters {
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

class oi4mongod::parameters (
	
	#$mongo_cluster_type = $::mongo_cluster_type,
	#$mongod_port = $::mongod_port,
	#$mongo_storage_smallFiles = $::mongo_storage_smallFiles,
	#$mongo_security_authorization = $::mongo_security_authorization,
	#$mongod_replicaset_name = $::mongod_replicaset_name,
	#$mongod_replicaset_oplogSizeMB = $::mongod_replicaset_oplogSizeMB,
	#$mongod_replicaset_node = $::mongod_replicaset_node,
	#$mongo_mongos_node = $::mongo_mongos_node,
) {
	#
	# Parameter validation and some default values
	#
	
	include stdlib
	$mongo_cluster_type=hiera('toas::mongod::mongo_cluster_type')
	$mongod_port=hiera('toas::mongod::mongod_port')
	$mongo_storage_smallFiles=hiera('toas::mongod::mongo_storage_smallFiles')
	$mongo_security_authorization=hiera('toas::mongod::mongo_security_authorization')
	$mongod_replicaset_name=hiera('toas::mongod::mongod_replicaset_name')
	$mongod_replicaset_oplogSizeMB=hiera('toas::mongod::mongod_replicaset_oplogSizeMB')
	$mongod_replicaset_node=hiera('toas::mongod::mongod_replicaset_node')
	$mongo_mongos_node=hiera('toas::mongod::mongo_mongos_node')
	
	
	# mongo_cluster_type
	if ($mongo_cluster_type == undef) { 
		fail("Parameter mongo_cluster_type undefined") 
	}
	if ($mongo_cluster_type !~ /^(standalone|replicaset|sharded)$/) { 
		fail("Invalid mongo_cluster_type value '$mongo_cluster_type'") 
	}
		
	# mongod_port
	if ($mongod_port == undef) { 
		if ($mongo_cluster_type == 'sharded') {
			$_mongod_port = '27018'
		} else {
			$_mongod_port = '27017'
		}
		notice("Using mongod_port=$_mongod_port") 
	} else {
		$_mongod_port = $mongod_port
	}
	if ($_mongod_port !~ /^[0-9]+$/) { 
		fail("Invalid mongod_port value '$mongod_port'") 
	}

	# mongo_storage_smallFiles
	if ($mongo_storage_smallFiles == undef) { 
		$_mongo_storage_smallFiles = 'false'
		notice("Using mongo_storage_smallFiles=$_mongo_storage_smallFiles") 
	} else {
		$_mongo_storage_smallFiles = $mongo_storage_smallFiles
	}
	if ($_mongo_storage_smallFiles !~ /^(true|false)$/) { 
		fail("Invalid mongo_storage_smallFiles value '$_mongo_storage_smallFiles'") 
	}
			
	# mongo_security_authorization
	if ($mongo_security_authorization == undef) { 
		$_mongo_security_authorization = 'disabled'
		notice("Using mongo_security_authorization=$_mongo_security_authorization") 
	} else {
		$_mongo_security_authorization = $mongo_security_authorization
	}
	if ($_mongo_security_authorization !~ /^(enabled|disabled)$/) { 
		fail("Invalid mongo_security_authorization value '$mongo_security_authorization'") 
	}
			
	if ($mongo_cluster_type != 'standalone') {
		# mongod_replicaset_oplogSizeMB
		if ($mongod_replicaset_oplogSizeMB == undef) { 
			$_mongod_replicaset_oplogSizeMB = 'default'
			notice("Using mongod_replicaset_oplogSizeMB=$_mongod_replicaset_oplogSizeMB") 
		} else {
			$_mongod_replicaset_oplogSizeMB = $mongod_replicaset_oplogSizeMB
		}
		if ($_mongod_replicaset_oplogSizeMB !~ /^([0-9]+|default)$/) { 
			fail("Invalid mongo_cluster_type value '$_mongo_cluster_type'") 
		}
	
		# mongod_replicaset_name
		if ($mongod_replicaset_name == undef) { 
			fail ("Parameter mongod_replicaset_name undefined")
		}
	
		# mongod_replicaset_node
		if ($mongod_replicaset_node == undef) { 
			fail ("Parameter mongod_replicaset_node undefined")
		}
		if ($mongod_replicaset_node !~ /^([-a-z0-9\.]+:[0-9]+)$/) { 
			fail("Invalid mongod_replicaset_node value '$mongod_replicaset_node'") 
		}
	}

	if ($mongo_cluster_type == 'sharded') {
		# mongo_mongos_node
		if ($mongo_mongos_node == undef) { 
			fail ("Parameter mongo_mongos_node undefined")
		}
		if ($mongo_mongos_node !~ /^([-a-z0-9\.]+:[0-9]+)$/) { 
			fail("Invalid mongo_mongos_node value '$mongo_mongos_node'") 
		}
	}

}

