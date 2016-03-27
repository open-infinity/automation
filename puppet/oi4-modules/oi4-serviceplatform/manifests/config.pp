class oi4-serviceplatform::config (
  $bas_multicast_address = undef,
  $sp_dbaddress = undef,
  $sp_nodeid = undef,
  $sp_amq_password = undef,
  $sp_activiti_password = undef,
  $sp_oi_dbuser_password = undef,
  $sp_extra_jvm_opts = undef,
  $sp_extra_catalina_opts = undef,
  $sp_oi_httpuser_pwd = undef,
  $sp_amq_stomp_conn_bindaddr = undef,
  $sp_amq_jms_conn_bindaddr = undef,
  $oi_home = undef,
) 

{
# NOTE [Vedran]
# Resources below are handled in oi4bas module, which handles bas technology related configuration.
# This fits well to relos-profiles pattern, and was a bug too, since:
# - catalina properties is double defined resource ->causes puppet error
# - oi4bas::bas::tomcatconf does not exist
#
#  file {"$oi_home/tomcat/conf/catalina.properties":
#    ensure => present,
#    owner => 'oiuser',
#    group => 'oiuser',
#    mode => 0600,
#    source => "puppet:///modules/oi4-serviceplatform/catalina.properties",
#    require => Class["oi4-serviceplatform::install"],
#    notify => Service["oi-tomcat"],
#  }
#  class { 'oi4bas::bas::tomcatconf':
#    oi_home => $oi_home
#  }

	tomcat::setenv::entry {"MULE_HOME": 
		value => "/opt/data"
	}

	tomcat::setenv::entry {"MULE_OPTS": 
		value => "-Dmule.workingDirectory=/opt/data/.mule"
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

    #file {"/opt/openinfinity/tomcat/webapps/activiti-rest2/WEB-INF/classes/activiti-context.xml":
    #    ensure => present,
    #    owner => 'oiuser',
    #    group => 'oiuser',
    #    mode => 0644,
    #    source => "puppet:///modules/oi4-serviceplatform/activiti-rest-context.xml",
    #    require => Class["oi4-serviceplatform::install"],
    #}

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

