class oi3-serviceplatform::config (
  $bas_multicast_address = undef,
  $sp_dbaddress = undef,
  $sp_nodeid = undef,
  $sp_amq_password = undef,
  $sp_activiti_password = undef,
  $sp_oi_dbuser_password = undef,
  $sp_jvmmem = undef,
  $sp_jvmperm = undef,
  $sp_extra_jvm_opts = undef,
  $sp_extra_catalina_opts = undef,
  $sp_oi_httpuser_pwd = undef,

  $sp_amq_stomp_conn_bindaddr = undef,
  $sp_amq_jms_conn_bindaddr = undef,
  
  $bas_tomcat_connector_attributes = undef,
  $bas_tomcat_ajp_connector_attributes = undef,
  $bas_tomcat_monitor_role_pw = undef
) inherits oi3variables {

  if $bas_multicast_address == undef {
    $_bas_multicast_address = $::multicastaddress
  }
  else {
    $_bas_multicast_address = $bas_multicast_address
  }
  if $sp_dbaddress == undef {
    $_sp_dbaddress = $::dbaddress
  }
  else {
    $_sp_dbaddress = $sp_dbaddress
  }
  if $sp_nodeid == undef {
    $_sp_nodeid = $::nodeid
  }
  else {
    $_sp_nodeid = $sp_nodeid
  }
  
  if $sp_amq_password == undef {
    $_sp_amq_password = $::amq_password
  }
  else {
    $_sp_amq_password = $sp_amq_password
  }
  if $sp_amq_jms_conn_bindaddr == undef {
    $_sp_amq_jms_conn_bindaddr = $::amq_jms_conn_bindaddr
  }
  else {
    $_sp_amq_jms_conn_bindaddr = $sp_amq_jms_conn_bindaddr
  }
  if $sp_amq_stomp_conn_bindaddr == undef {
    $_sp_amq_stomp_conn_bindaddr = $::amq_stomp_conn_bindaddr
  }
  else {
    $_sp_amq_stomp_conn_bindaddr = $sp_amq_stomp_conn_bindaddr
  }
  if $sp_activiti_password == undef {
   $_sp_activiti_password = $::activiti_password
  }
  else {
    $_sp_activiti_password = $sp_activiti_password
  }
  if $sp_oi_dbuser_password == undef {
    $_sp_oi_dbuser_password = $::oi_dbuser_password
  }
  else {
    $_sp_oi_dbuser_password = $sp_oi_dbuser_password
  }
  if $sp_jvmmem == undef {
    $_sp_jvmmem = $::jvmmem
  }
  else {
    $_sp_jvmmem =  $sp_jvmmem
  }
  if $sp_jvmperm == undef {
    $_sp_jvmperm = $::jvmperm
  }
  else {
    $_sp_jvmperm = $sp_jvmperm
  }
  if $sp_extra_jvm_opts == undef {
    $_sp_extra_jvm_opts = $::extra_jvm_opts
  }
  else {
    $_sp_extra_jvm_opts = $sp_extra_jvm_opts
  }
  if $sp_extra_catalina_opts == undef {
    $_sp_extra_catalina_opts = $::extra_catalina_opts
  }
  else {
    $_sp_extra_catalina_opts = $sp_extra_catalina_opts
  }
  if $sp_oi_httpuser_pwd == undef {
    $_sp_oi_httpuser_pwd = $::oi_httpuser_pwd
  }
  else {
    $_sp_oi_httpuser_pwd = $sp_oi_httpuser_pwd
  }
  if $bas_tomcat_connector_attributes == undef {
    $_bas_tomcat_connector_attributes = $::tomcat_connector_attributes
  }
  else {
     $_bas_tomcat_connector_attributes = $bas_tomcat_connector_attributes
  }
  if $bas_tomcat_ajp_connector_attributes == undef {
    $_bas_tomcat_ajp_connector_attributes = $::ajp_connector_attributes
  }
  else {
    $_bas_tomcat_ajp_connector_attributes = $bas_tomcat_ajp_connector_attributes
  }
  if $bas_tomcat_monitor_role_pw == undef {
    $_bas_tomcat_monitor_role_pw = $::tomcat_monitor_role_pw
  }
  else {
    $_bas_tomcat_monitor_role_pw = $bas_tomcat_monitor_role_pw
  }  

    file { "/opt/openinfinity/3.1.0/tomcat/bin/setenv.sh":
        ensure => present,
        owner => 'oiuser',
        group => 'oiuser',
        mode => 0755,
        content => template("oi3-serviceplatform/setenv.sh.erb"),
        require => Class["oi3-serviceplatform::install"],
        notify => Service["oi-tomcat"],
    }

    file {"/opt/openinfinity/3.1.0/tomcat/conf/catalina.properties":
        ensure => present,
        owner => 'oiuser',
        group => 'oiuser',
        mode => 0600,
        source => "puppet:///modules/oi3-serviceplatform/catalina.properties",
        require => Class["oi3-serviceplatform::install"],
        notify => Service["oi-tomcat"],
    }

    file {"/opt/openinfinity/3.1.0/tomcat/conf/tomcat-users.xml":
        ensure => present,
        owner => 'oiuser',
        group => 'oiuser',
        mode => 0644,
        content => template("oi3-serviceplatform/tomcat-users.xml.erb"),
        require => Class["oi3-serviceplatform::install"],
    }


    #rights may require change
    $activemqxml = '/opt/openinfinity/3.1.0/tomcat/conf/activemq.xml'
    
    concat{$activemqxml:
        owner => 'oiuser',
        group => 'oiuser',
        mode => 0644,
    }
    
    
    concat::fragment{'amqxml_start':
	target =>  $activemqxml,
        content => template("oi3-serviceplatform/frag_start_activemq.xml.erb"),
	order => '01',
    }

    # concat by undef and def parameters
  if $_sp_amq_jms_conn_bindaddr != undef {
	concat::fragment{'amqxml_jmsconnector':
	  target =>  $activemqxml,
	  content => template("oi3-serviceplatform/frag_jmsconnector_activemq.xml.erb"),
	  order => '10',
	}	  
  }	  
  if $_sp_amq_stomp_conn_bindaddr != undef {
	concat::fragment{'amqxml_stompconnector':
	  target =>  $activemqxml,
	  content => template("oi3-serviceplatform/frag_stompconnector_activemq.xml.erb"),
	  order => '10',
	}	  
  }	  
    
    
    concat::fragment{'amqxml_end':
	target =>  $activemqxml,
        content => template("oi3-serviceplatform/frag_end_activemq.xml.erb"),
	order => '15',
    }
    
    
    file {"/opt/data/.mule":
        ensure => directory,
        owner => 'oiuser',
        group => 'oiuser',
        mode => 0644,
        require => Class["oi3-serviceplatform::install"],
    }

    # activity webapp configuration override

    file {"/opt/openinfinity/3.1.0/tomcat/webapps/activiti-explorer2/WEB-INF/classes/db.properties":
        ensure => present,
        owner => 'oiuser',
        group => 'oiuser',
        mode => 0644,
        content => template("oi3-serviceplatform/activiti.db.properties.erb"),
        require => Class["oi3-serviceplatform::install"],
    }

    file {"/opt/openinfinity/3.1.0/tomcat/webapps/activiti-rest2/WEB-INF/classes/db.properties":
        ensure => present,
        owner => 'oiuser',
        group => 'oiuser',
        mode => 0644,
        content => template("oi3-serviceplatform/activiti.db.properties.erb"),
        require => Class["oi3-serviceplatform::install"],
    }
    
    file {"/opt/openinfinity/3.1.0/tomcat/webapps/activiti-explorer2/WEB-INF/activiti-standalone-context.xml":
        ensure => present,
        owner => 'oiuser',
        group => 'oiuser',
        mode => 0644,
        source => "puppet:///modules/oi3-serviceplatform/activiti-explorer-standalone-context.xml",     
        require => Class["oi3-serviceplatform::install"],
    }
    
    file {"/opt/openinfinity/3.1.0/tomcat/webapps/activiti-rest2/WEB-INF/classes/activiti-context.xml":
        ensure => present,
        owner => 'oiuser',
        group => 'oiuser',
        mode => 0644,
        source => "puppet:///modules/oi3-serviceplatform/activiti-rest-context.xml",        
        require => Class["oi3-serviceplatform::install"],
    }
    
    file {"/opt/openinfinity/3.1.0/tomcat/webapps/activiti-rest2/WEB-INF/web.xml":
        ensure => present,
        owner => 'oiuser',
        group => 'oiuser',
        mode => 0644,
        source => "puppet:///modules/oi3-serviceplatform/activiti-rest-web.xml",        
        require => Class["oi3-serviceplatform::install"],
    }

    # activemq-web-console webapp configuration override

    file {"/opt/openinfinity/3.1.0/tomcat/webapps/activemq-web-console/WEB-INF/webconsole-embedded.xml":
        ensure => present,
        owner => 'oiuser',
        group => 'oiuser',
        mode => 0644,
        source => "puppet:///modules/oi3-serviceplatform/webconsole-embedded.xml",      
        require => Class["oi3-serviceplatform::install"],
    }

    file {"/opt/openinfinity/3.1.0/tomcat/webapps/activemq-web-console/WEB-INF/web.xml":
        ensure => present,
        owner => 'oiuser',
        group => 'oiuser',
        mode => 0644,
        source => "puppet:///modules/oi3-serviceplatform/amqwebconsole_web.xml",        
        require => Class["oi3-serviceplatform::install"],
    }

    # oauth webapp configuration override
    file {"/opt/openinfinity/3.1.0/tomcat/webapps/oauth/WEB-INF/classes/oauth-repository.properties":
        ensure => present,
        owner => 'oiuser',
        group => 'oiuser',
        mode => 0644,
        content => template("oi3-serviceplatform/oauth-repository.properties.erb"),
        require => Class["oi3-serviceplatform::install"],
    }

#    # ActiveMQ web console credentials
#   file {"/opt/openinfinity/3.1.0/tomcat/conf/credentials.properties":
#       ensure => present,
#       owner => 'oiuser',
#       group => 'oiuser',
#       mode => 0600,
#       content => template("oi3-serviceplatform/credentials.properties.erb"),
#       require => Class["oi3-serviceplatform::install"],
#   }

#   # ActiveMQ SiteMesh dependency file
#   file {"/opt/openinfinity/3.1.0/tomcat/webapps/activemq-web-console/WEB-INF/decorators.xml":
#       ensure => present,
#       owner => 'oiuser',
#       group => 'oiuser',
#       mode => 0600,
#       content => template("oi3-serviceplatform/decorators.xml.erb"),
#       require => Class["oi3-serviceplatform::install"],
#   }

    # ---- From oi3-bas --------------------------------------------------------
    file {"/opt/openinfinity/3.1.0/tomcat/conf/server.xml":
        ensure => present,
        owner => 'oiuser',
        group => 'oiuser',
        mode => 0600,
        #source => "puppet:///modules/oi3-bas/server.xml",
        content => template("oi3-bas/server.xml.erb"),
        require => Class["oi3-serviceplatform::install"],
    }

    # Security Vault configuration
    file {"/opt/openinfinity/3.1.0/tomcat/conf/securityvault.properties":
        ensure => present,
        owner => 'oiuser',
        group => 'oiuser',
        mode => 0600,
        source => "puppet:///modules/oi3-bas/securityvault.properties",
        require => Class["oi3-serviceplatform::install"],
    }

    file {"/opt/openinfinity/3.1.0/tomcat/conf/context.xml.openinfinity_example":
        ensure => present,
        owner => 'oiuser',
        group => 'oiuser',
        mode => 0600,
        source => "puppet:///modules/oi3-bas/context.xml",
        require => Class["oi3-serviceplatform::install"],
    }

    file {"/opt/openinfinity/3.1.0/tomcat/conf/hazelcast.xml":
        ensure => present,
        owner => 'oiuser',
        group => 'oiuser',
        mode => 0600,
        content => template("oi3-bas/hazelcast.xml.erb"),
        require => Class["oi3-serviceplatform::install"],
    }

    file {"/etc/init.d/oi-tomcat":
        ensure => present,
        owner => 'root',
        group => 'root',
        mode => 0755,
        #source => "puppet:///modules/oi3-bas/oi-tomcat",
        content => template("oi3-bas/oi-tomcat.erb"),
        require => Class["oi3-serviceplatform::install"],
    }
    
    file {"/opt/openinfinity/3.1.0/tomcat/conf/jmxremote.password":
        ensure => present,
        owner => 'oiuser',
        group => 'oiuser',
        mode => 0600,
        content => template("oi3-bas/jmxremote.password.erb"),
        require => Class["oi3-serviceplatform::install"],
    }
        
    file {"/opt/openinfinity/3.1.0/tomcat/conf/jmxremote.access":
        ensure => present,
        owner => 'oiuser',
        group => 'oiuser',
        mode => 0644,
        source => "puppet:///modules/oi3-bas/jmxremote.access",
        require => Class["oi3-serviceplatform::install"],
    }

    # Try ensure, that the supported Java is chosen
        exec { "choose-java":
        path => "/",
        command => "${alternativesPath} --install /usr/bin/java java ${javaHome}/bin/java 190000",
        unless => "${alternativesPath} --display java | /bin/grep 'link currently points to ${javaHome}/bin/java'",
        require => Package[$javaPackageName],
    }
}

