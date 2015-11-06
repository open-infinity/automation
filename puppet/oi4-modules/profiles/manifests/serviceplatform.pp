class profiles::serviceplatform {
  $bas_multicast_address = hiera('toas::bas:multicast_address')
  $sp_dbaddress = hiera('toas::sp::dbaddress')
  $sp_nodeid =  hiera('toas::sp::nodeid')
  $sp_amq_password = hiera('toas::sp::amq_password')
  $sp_activiti_password = hiera('toas::sp::activiti_password')
  $sp_oi_dbuser_password = hiera('toas::sp::dbuser_password')
  $sp_jvmmem =  hiera('toas::sp::jvmmem')
  $sp_jvmperm =  hiera('toas::sp::jvmperm')
  $sp_extra_jvm_opts =  hiera('toas::sp::extra_jvm_opts')
  $sp_extra_catalina_opts =  hiera('toas::sp::extra_catalina_opts')
  $sp_oi_httpuser_pwd =  hiera('toas::sp::oi_httpuser_pwd')
  $sp_amq_stomp_conn_bindaddr =  hiera('toas::sp::amq_stomp_conn_bindaddr')
  $sp_amq_jms_conn_bindaddr =  hiera('toas::sp::amq_jms_conn_bindaddr')
  $bas_tomcat_connector_attributes =  hiera('toas::bas::tomcat_connector_attributes')
  $bas_tomcat_ajp_connector_attributes =  hiera('toas::bas::tomcat_ajp_connector_attributes')
  $bas_tomcat_monitor_role_pw =  hiera('toas::bas::tomcat_monitor_role_pw')

  class {'oi4-serviceplatform::install':
  }->
  class {'oi4-serviceplatform::config': 
	  bas_multicast_address => $bas_multicast_address,
	  sp_dbaddress => $sp_dbaddress,
	  sp_nodeid => $sp_nodeid,
	  sp_amq_password => $sp_amq_password,
	  sp_activiti_password => $sp_activiti_password,
	  sp_oi_dbuser_password =>  $sp_oi_dbuser_password,
	  sp_jvmmem => $sp_jvmmem,
	  sp_jvmperm =>  $sp_jvmperm,
	  sp_extra_jvm_opts => $sp_extra_catalina_opts,
	  sp_extra_catalina_opts =>  $sp_extra_catalina_opts,
	  sp_oi_httpuser_pwd => $sp_oi_httpuser_pwd,
	  sp_amq_stomp_conn_bindaddr =>  $sp_amq_stomp_conn_bindaddr ,
	  sp_amq_jms_conn_bindaddr =>  $sp_amq_jms_conn_bindaddr,
	  bas_tomcat_connector_attributes => $bas_tomcat_connector_attributes,
	  bas_tomcat_ajp_connector_attributes => $bas_tomcat_ajp_connector_attributes,
	  bas_tomcat_monitor_role_pw => $bas_tomcat_monitor_role_pw 
  }->
  class {'oi4-serviceplatform::service':
  }


}


