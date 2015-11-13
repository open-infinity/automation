class oi4-serviceplatform::config (
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
  $oi_home = undef
) 

{
	$tomcat_home = "${oi_home}/tomcat"
	tomcat::setenv::entry {"MULE_HOME": 
		value => "/opt/data"
	}

	tomcat::setenv::entry {"MULE_OPTS": 
		value => "-Dmule.workingDirectory=/opt/data/.mule"
	}

	tomcat::setenv::entry {"package.access": 
		config_file => "${tomcat_home}/conf/catalina.properties",
		value => "sun.,org.apache.catalina.,org.apache.coyote.,org.apache.tomcat.,org.apache.jasper.,sun.beans."
	}

	tomcat::setenv::entry {"package.definition": 
		config_file => "${tomcat_home}/conf/catalina.properties",
		value => "sun.,java.,org.apache.catalina.,org.apache.coyote.,org.apache.tomcat.,org.apache.jasper."
	}
	tomcat::setenv::entry {"common.loader": 
		config_file => "${tomcat_home}/conf/catalina.properties",
		value => '${catalina.base}/lib,${catalina.base}/lib/*.jar,${catalina.home}/lib,${catalina.home}/lib/*.jar,${catalina.home}/lib/ext/*.jar,${catalina.home}/lib/oi-core-libs/*.jar,${catalina.home}/lib/oi-core-libs/deps/*.jar,${catalina.home}/lib/oi-hazelcast-libs/*.jar,${catalina.home}/lib/oi-mvcclient-libs/*.jar,${catalina.home}/lib/oi-secvault-libs/*.jar,${catalina.home}/lib/oi-mule-libs/endorsed/*.jar,${catalina.home}/lib/oi-mule-libs/mule/*.jar,${catalina.home}/lib/oi-mule-libs/opt/*.jar,${catalina.home}/lib/oi-activemq-libs/*.jar,${catalina.home}/lib/oi-activemq-libs/opt/*.jar,${catalina.home}/lib/oi-activemq-libs/web/*.jar,${catalina.home}/lib/oi-activemq-libs/camel/*.jar,${catalina.home}/lib/oi-activiti-libs/*.jar,${catalina.home}/lib/oi-activiti-libs/deps/*.jar,${catalina.home}/lib/oi-activiti-libs/mule-module-activiti/*.jar,${catalina.home}/lib/oi-activiti-libs/mule-module-activiti/deps/*.jar,${catalina.home}/lib/springdata-commons-libs/*.jar,${catalina.home}/lib/springdata-commons-libs/deps/*.jar,${catalina.home}/lib/springdata-mongo-libs/*.jar,${catalina.home}/lib/springdata-mongo-libs/deps/*.jar,${catalina.home}/lib/oi-springdatahadoop-libs/spring-data-hadoop-core/*.jar,${catalina.home}/lib/oi-springdatahadoop-libs/spring-data-hadoop-core/deps/*.jar,${catalina.home}/lib/oi-springdatahadoop-libs/spring-data-hadoop/*.jar,${catalina.home}/lib/oi-springdatahadoop-libs/spring-data-hadoop/deps/*.jar,${catalina.home}/lib/oi-springdatahadoop-libs/spring-cascading/*.jar,${catalina.home}/lib/oi-springdatahadoop-libs/spring-cascading/deps/*.jar,${catalina.home}/lib/oi-springdatahadoop-libs/spring-data-hadoop-batch/*.jar,${catalina.home}/lib/oi-springdatahadoop-libs/spring-data-hadoop-batch/deps/*.jar,${catalina.home}/lib/oi-ssocommon-libs/*.jar,${catalina.home}/lib/oi-ssocommon-libs/dependencies/*.jar'
	}

	tomcat::setenv::entry {"tomcat.util.buf.StringCache.byte.enabled": 
		config_file => "${tomcat_home}/conf/catalina.properties",
		value => "true"
	}
	
    file {"/opt/openinfinity/tomcat/conf/tomcat-users.xml":
        ensure => present,
        owner => 'oiuser',
        group => 'oiuser',
        mode => 0644,
        content => template("oi4-serviceplatform/tomcat-users.xml.erb"),
        require => Class["oi4-serviceplatform::install"],
    }


    #rights may require change
    $activemqxml = "/opt/openinfinity/tomcat/conf/activemq.xml"
    concat{$activemqxml:
        owner => 'oiuser',
        group => 'oiuser',
        mode => 0644,
    }


    concat::fragment{'amqxml_start':
	    target =>  $activemqxml,
      content => template("oi4-serviceplatform/frag_start_activemq.xml.erb"),
      order => '01',
    }

    # concat by undef and def parameters
    if $sp_amq_jms_conn_bindaddr != undef {
	    concat::fragment{'amqxml_jmsconnector':
	      target =>  $activemqxml,
	      content => template("oi4-serviceplatform/frag_jmsconnector_activemq.xml.erb"),
	      order => '10',
	    }
    }
    if $sp_amq_stomp_conn_bindaddr != undef {
	    concat::fragment{'amqxml_stompconnector':
	    target =>  $activemqxml,
	    content => template("oi4-serviceplatform/frag_stompconnector_activemq.xml.erb"),
	    order => '10',
	  }
  }


    concat::fragment{'amqxml_end':
	    target =>  $activemqxml,
      content => template("oi4-serviceplatform/frag_end_activemq.xml.erb"),
	    order => '15',
    }

    file {"/opt/data/.mule":
        ensure => directory,
        owner => 'oiuser',
        group => 'oiuser',
        mode => 0644,
        require => Class["oi4-serviceplatform::install"],
    }

    # activity webapp configuration override

    file {"/opt/openinfinity/tomcat/webapps/activiti-explorer2/WEB-INF/classes/db.properties":
        ensure => present,
        owner => 'oiuser',
        group => 'oiuser',
        mode => 0644,
        content => template("oi4-serviceplatform/activiti.db.properties.erb"),
        require => Class["oi4-serviceplatform::install"],
    }

    file {"/opt/openinfinity/tomcat/webapps/activiti-rest2/WEB-INF/classes/db.properties":
        ensure => present,
        owner => 'oiuser',
        group => 'oiuser',
        mode => 0644,
        content => template("oi4-serviceplatform/activiti.db.properties.erb"),
        require => Class["oi4-serviceplatform::install"],
    }

    file {"/opt/openinfinity/tomcat/webapps/activiti-explorer2/WEB-INF/activiti-standalone-context.xml":
        ensure => present,
        owner => 'oiuser',
        group => 'oiuser',
        mode => 0644,
        source => "puppet:///modules/oi4-serviceplatform/activiti-explorer-standalone-context.xml",
        require => Class["oi4-serviceplatform::install"],
    }

    file {"/opt/openinfinity/tomcat/webapps/activiti-rest2/WEB-INF/classes/activiti-context.xml":
        ensure => present,
        owner => 'oiuser',
        group => 'oiuser',
        mode => 0644,
        source => "puppet:///modules/oi4-serviceplatform/activiti-rest-context.xml",
        require => Class["oi4-serviceplatform::install"],
    }

    file {"/opt/openinfinity/tomcat/webapps/activiti-rest2/WEB-INF/web.xml":
        ensure => present,
        owner => 'oiuser',
        group => 'oiuser',
        mode => 0644,
        source => "puppet:///modules/oi4-serviceplatform/activiti-rest-web.xml",
        require => Class["oi4-serviceplatform::install"],
    }

    # activemq-web-console webapp configuration override

    file {"/opt/openinfinity/tomcat/webapps/activemq-web-console/WEB-INF/webconsole-embedded.xml":
        ensure => present,
        owner => 'oiuser',
        group => 'oiuser',
        mode => 0644,
        source => "puppet:///modules/oi4-serviceplatform/webconsole-embedded.xml",
        require => Class["oi4-serviceplatform::install"],
    }

    file {"/opt/openinfinity/tomcat/webapps/activemq-web-console/WEB-INF/web.xml":
        ensure => present,
        owner => 'oiuser',
        group => 'oiuser',
        mode => 0644,
        source => "puppet:///modules/oi4-serviceplatform/amqwebconsole_web.xml",
        require => Class["oi4-serviceplatform::install"],
    }

    # oauth webapp configuration override
    file {"/opt/openinfinity/tomcat/webapps/oauth/WEB-INF/classes/oauth-repository.properties":
        ensure => present,
        owner => 'oiuser',
        group => 'oiuser',
        mode => 0644,
        content => template("oi4-serviceplatform/oauth-repository.properties.erb"),
        require => Class["oi4-serviceplatform::install"],
    }

}

