class profiles::nosql {
	$mongod_replicaset_name=hiera('toas::mongod::mongod_replicaset_name')
    $mongo_cluster_type=hiera('toas::mongod::mongo_cluster_type')
	$_mongod_port=hiera('toas::mongod::mongod_port')
	$_mongo_storage_smallFiles=hiera('toas::mongod::mongo_storage_smallFiles')
	$_mongo_security_authorization=hiera('toas::mongod::mongo_security_authorization')
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
	if ($_mongod_port == undef) { 
		if ($mongo_cluster_type == 'sharded') {
			$mongod_port = '27018'
		} else {
			$mongod_port = '27017'
		}
		notice("Using mongod_port=$mongod_port") 
	}  else {
		$mongod_port = $_mongod_port
	}
	
	if ($mongod_port !~ /^[0-9]+$/) { 
		fail("Invalid mongod_port value '$mongod_port'") 
	}

	# mongo_storage_smallFiles
	if ($_mongo_storage_smallFiles == undef) { 
		$mongo_storage_smallFiles = 'false'
		notice("Using mongo_storage_smallFiles=$mongo_storage_smallFiles") 
	} else
	{
		$mongo_storage_smallFiles = $_mongo_storage_smallFiles
	}
	
	if ($mongo_storage_smallFiles !~ /^(true|false)$/) { 
		fail("Invalid mongo_storage_smallFiles value '$mongo_storage_smallFiles'") 
	}
			
	# mongo_security_authorization
	if ($_mongo_security_authorization == undef) { 
		$mongo_security_authorization = 'disabled'
		notice("Using mongo_security_authorization=$mongo_security_authorization") 
	} else 
	{
		$mongo_security_authorization = $_mongo_security_authorization
	}
	
	if ($mongo_security_authorization !~ /^(enabled|disabled)$/) { 
		fail("Invalid mongo_security_authorization value '$mongo_security_authorization'") 
	}
			
	if ($mongo_cluster_type != 'standalone') {
		# mongod_replicaset_oplogSizeMB
		if ($mongod_replicaset_oplogSizeMB == undef) { 
			$mongod_replicaset_oplogSizeMB = 'default'
			notice("Using mongod_replicaset_oplogSizeMB=$mongod_replicaset_oplogSizeMB") 
		}
		
		if ($mongod_replicaset_oplogSizeMB !~ /^([0-9]+|default)$/) { 
			fail("Invalid mongo_cluster_type value '$mongo_cluster_type'") 
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
  class {'oi4mongocommon':
  }-> class {'oi4mongod': 
	mongo_cluster_type => $mongo_cluster_type,
	mongod_port => $mongod_port,
	mongo_storage_smallFiles => $mongo_storage_smallFiles, 
	mongo_security_authorization => $mongo_security_authorization, 
	mongod_replicaset_name => $mongod_replicaset_name, 
	mongod_replicaset_oplogSizeMB => $mongod_replicaset_oplogSizeMB, 
	mongod_replicaset_node => $mongod_replicaset_node, 
	mongo_mongos_node => $mongo_mongos_node
  } 
}
