class oi4bas::config (
  $bas_multicast_address = undef,
  $bas_tomcat_monitor_role_pwd = undef,
  $oi_home = '/opt/openinfinity',
) 

{	
	$tomcat_home = "${oi_home}/tomcat"

	tomcat::setenv::entry {"package.access": 
		config_file => "${tomcat_home}/conf/catalina.properties",
		value => "sun.,org.apache.catalina.,org.apache.coyote.,org.apache.jasper.,org.apache.tomcat."
	}

	tomcat::setenv::entry {"package.definition": 
		config_file => "${tomcat_home}/conf/catalina.properties",
		value => "sun.,java.,org.apache.catalina.,org.apache.coyote.,org.apache.jasper.,org.apache.naming.,org.apache.tomcat."
	}
	tomcat::setenv::entry {"common.loader": 
		config_file => "${tomcat_home}/conf/catalina.properties",
		value => '${catalina.base}/lib","${catalina.base}/lib/*.jar","${catalina.home}/lib","${catalina.home}/lib/*.jar","${catalina.home}/lib/ext/*.jar","${catalina.home}/lib/oi-core-libs/*.jar","${catalina.home}/lib/oi-core-libs/deps/*.jar","${catalina.home}/lib/ext/liferay-portal-dependencies/*.jar","${catalina.home}/lib/oi-hazelcast-libs/*.jar","${catalina.home}/lib/oi-secvault-libs/*.jar'
	}

	tomcat::setenv::entry {"tomcat.util.scan.StandardJarScanFilter.jarsToSkip": 
		config_file => "${tomcat_home}/conf/catalina.properties",
		value => '\
		bootstrap.jar,commons-daemon.jar,tomcat-juli.jar,\
		annotations-api.jar,el-api.jar,jsp-api.jar,servlet-api.jar,websocket-api.jar,\
		catalina.jar,catalina-ant.jar,catalina-ha.jar,catalina-storeconfig.jar,\
		catalina-tribes.jar,\
		jasper.jar,jasper-el.jar,ecj-*.jar,\
		tomcat-api.jar,tomcat-util.jar,tomcat-util-scan.jar,tomcat-coyote.jar,\
		tomcat-dbcp.jar,tomcat-jni.jar,tomcat-websocket.jar,\
		tomcat-i18n-en.jar,tomcat-i18n-es.jar,tomcat-i18n-fr.jar,tomcat-i18n-ja.jar,\
		tomcat-juli-adapters.jar,catalina-jmx-remote.jar,catalina-ws.jar,\
		tomcat-jdbc.jar,\
		tools.jar,\
		commons-beanutils*.jar,commons-codec*.jar,commons-collections*.jar,\
		commons-dbcp*.jar,commons-digester*.jar,commons-fileupload*.jar,\
		commons-httpclient*.jar,commons-io*.jar,commons-lang*.jar,commons-logging*.jar,\
		commons-math*.jar,commons-pool*.jar,\
		jstl.jar,taglibs-standard-spec-*.jar,\
		geronimo-spec-jaxrpc*.jar,wsdl4j*.jar,\
		ant.jar,ant-junit*.jar,aspectj*.jar,jmx.jar,h2*.jar,hibernate*.jar,httpclient*.jar,\
		jmx-tools.jar,jta*.jar,log4j*.jar,mail*.jar,slf4j*.jar,\
		xercesImpl.jar,xmlParserAPIs.jar,xml-apis.jar,\
		junit.jar,junit-*.jar,ant-launcher.jar,\
		cobertura-*.jar,asm-*.jar,dom4j-*.jar,icu4j-*.jar,jaxen-*.jar,jdom-*.jar,\
		jetty-*.jar,oro-*.jar,servlet-api-*.jar,tagsoup-*.jar,xmlParserAPIs-*.jar,\
		xom-*.jar'
	}

	tomcat::setenv::entry {"tomcat.util.buf.StringCache.byte.enabled": 
		config_file => "${tomcat_home}/conf/catalina.properties",
		value => "true"
	}

  # Security Vault configuration
  file {"$oi_home/tomcat/conf/securityvault.properties":
    ensure => present,
    owner => 'oiuser',
    group => 'oiuser',
    mode => 0600,
    content => template("oi4bas/securityvault.properties.erb"),
    require => Class["oi4bas::install"],
  }

  file {"$oi_home/tomcat/conf/hazelcast.xml":
    ensure => present,
    owner => 'oiuser',
    group => 'oiuser',
    mode => 0600,
    content => template("oi4bas/hazelcast.xml.erb"),
    require => Class["oi4bas::install"],
  }

  file {"/etc/init.d/oi-tomcat":
    ensure => present,
    owner => 'root',
    group => 'root',
    mode => 0755,
    content => template("oi4bas/oi-tomcat.erb"),
    require => Class["oi4bas::install"],
  }

  file {"$oi_home/tomcat/conf/jmxremote.password":
    ensure => present,
    owner => 'oiuser',
    group => 'oiuser',
    mode => 0600,
    content => template("oi4bas/jmxremote.password.erb"),
    require => Class["oi4bas::install"],
  }

  file {"$oi_home/tomcat/conf/jmxremote.access":
    ensure => present,
    owner => 'oiuser',
    group => 'oiuser',
    mode => 0644,
    source => "puppet:///modules/oi4bas/jmxremote.access",
    require => Class["oi4bas::install"],
  }

}


