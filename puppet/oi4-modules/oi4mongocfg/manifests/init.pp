#
# MongoDB Configuration Server
#
# See our Confluence for more information about the parameters.
#

class oi4mongocfg {
    require oi4mongocfg::install
    require oi4mongocfg::config
    require oi4mongocfg::service
}

class oi4mongocfg::install inherits oi4mongocommon {
}

class oi4mongocfg::config inherits oi4mongocfg::variables {
    # Directories to be created
    $mongo_directories = [
        "/opt/openinfinity/data/mongocfg",
    ]
    file { $mongo_directories:
        ensure => "directory",
        owner => 'mongod',
        group => 'mongod',
        mode => 0755,
        require => Class["oi4mongocfg::install"],
     }

    file { '/etc/mongocfg.conf':
        ensure => present,
        notify => Service["mongocfg"],
        owner => "mongod",
        group => "mongod",
        content => template("oi4mongocfg/mongocfg.conf.erb"),
        require => Class["oi4mongocfg::install"],
    }
    
    file { '/etc/init.d/mongocfg':
        ensure => present,
        notify => Service["mongocfg"],
        owner => "root",
        group => "root",
        mode => 0755,
        source => "puppet:///modules/oi4mongocfg/mongocfg",
        require => Class["oi4mongocfg::install"],
    }

    file { '/etc/sysconfig/mongocfg':
        ensure => present,
        notify => Service["mongocfg"],
        owner => "mongod",
        group => "mongod",
        source => "puppet:///modules/oi4mongocfg/sysconfig-mongocfg",
        require => Class["oi4mongocfg::install"],
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

class oi4mongocfg::variables (
	$mongo_cluster_type = $::mongo_cluster_type,
	$mongocfg_port = $::mongocfg_port,
	$mongo_storage_smallFiles = $::mongo_storage_smallFiles,
	$mongo_security_authorization = $::mongo_security_authorization,
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
		fail("Mongo config server is needed in a sharded cluster type only.") 
	}
		
	# mongocfg_port
	if ($mongocfg_port == undef) { 
		$_mongocfg_port = '27019'
		notice("Using mongocfg_port=$_mongocfg_port") 
	} else {
		$_mongocfg_port = $mongocfg_port
	}
	if ($_mongocfg_port !~ /^[0-9]+$/) { 
		fail("Invalid mongocfg_port value '$mongocfg_port'") 
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
}

