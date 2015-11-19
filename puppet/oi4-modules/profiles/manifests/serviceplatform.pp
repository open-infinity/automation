class profiles::serviceplatform {
  $bas_multicast_address = hiera('toas::bas:multicast_address')
  $sp_dbaddress = hiera('toas::sp::dbaddress')
  $sp_nodeid =  hiera('toas::sp::nodeid')
  $sp_activiti_password = hiera('toas::rdbms::activiti::pw')
  $mariadb_root_password = hiera('toas::mariadb::root_password')
  $sp_jvmmem =  hiera('toas::sp::jvmmem')
  $sp_jvmperm =  hiera('toas::sp::jvmperm')
  $sp_extra_jvm_opts =  hiera('toas::sp::extra_jvm_opts', undef)
  $sp_extra_catalina_opts =  hiera('toas::sp::extra_catalina_opts', undef)
  $sp_oi_httpuser_pwd =  hiera('toas::sp::oi_httpuser_pwd')
  $sp_amq_stomp_conn_bindaddr =  hiera('toas::sp::amq_stomp_conn_bindaddr', undef)
  $sp_amq_jms_conn_bindaddr =  hiera('toas::sp::amq_jms_conn_bindaddr', undef)
  $activemq_password = hiera('toas::rdbms::activemq:pw')
  $oi_home = hiera('toas::oi_home', '/opt/openinfinity')

class {'oi4-serviceplatform::install':
	 require => Class["oi4bas::install"]
  }->
  class {'oi4-serviceplatform::config': 
	  bas_multicast_address => $bas_multicast_address,
	  sp_dbaddress => $sp_dbaddress,
	  sp_nodeid => $sp_nodeid,
	  sp_amq_password => $activemq_password,
	  sp_activiti_password => $sp_activiti_password,
	  sp_oi_dbuser_password =>  $mariadb_root_password,
	  sp_jvmmem => $sp_jvmmem,
	  sp_jvmperm =>  $sp_jvmperm,
	  sp_extra_jvm_opts => $sp_extra_catalina_opts,
	  sp_extra_catalina_opts =>  $sp_extra_catalina_opts,
	  sp_oi_httpuser_pwd => $sp_oi_httpuser_pwd,
	  sp_amq_stomp_conn_bindaddr =>  $sp_amq_stomp_conn_bindaddr ,
	  sp_amq_jms_conn_bindaddr =>  $sp_amq_jms_conn_bindaddr,
	  oi_home => $oi_home
  }->
  class {'oi4-serviceplatform::service':
  }
}


