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

class oi3mongos::config inherits oi3mongos::parameters {
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

class oi3mongos::parameters (
	$mongo_cluster_type = $::mongo_cluster_type,
	$mongos_port = $::mongos_port,
	$mongo_config_servers = $::mongo_config_servers,
) {
	#
	# Parameter validation and some default values
	#
	
	# mongo_cluster_type
	if ($mongo_cluster_type == undef) { 
		fail("Parameter mongo_cluster_type undefined") 
	}
	if ($mongo_cluster_type !~ /^(standalone|replicaset|sharded)$/) { 
		fail("Invalid mongo_cluster_type value '$mongo_cluster_type'") 
	}
	if ($mongo_cluster_type != 'sharded') {
		fail("Mongo routing process (mongos) is needed in a sharded cluster type only.") 
	}
		
	# mongos_port
	if ($mongos_port == undef) { 
		$_mongos_port = '27017'
		notice("Using mongos_port=$_mongos_port") 
	} else {
		$_mongos_port = $mongos_port
	}
	if ($_mongos_port !~ /^[0-9]+$/) { 
		fail("Invalid mongos_port value '$mongos_port'") 
	}
	
	# mongo_config_servers
	if ($mongo_config_servers == undef) { 
		fail("Parameter mongo_config_servers undefined") 
	}
	if ($mongo_config_servers !~ /^([-a-z0-9\.]+|[-a-z0-9\.]+,[-a-z0-9\.]+,[-a-z0-9\.]+)$/) { 
		fail("Invalid mongo_config_servers value '$mongo_config_servers'") 
	}
}

