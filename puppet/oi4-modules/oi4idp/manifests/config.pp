class oi4idp::config {
#include oi4-serviceplatform::service

$platform_name = "${tomcat::params::platform_name}"
	notify {"running config":}
	require oi4idp::params
	$java_home="${oi4idp::params::java_home}"
	#dot='.'
	#platform_home_prefix = "/opt/platform/"
	#platform_home_suffix = "/current"
	#$platform_home = "${platform_home_prefix}${platform_name}${platform_home_suffix}"
    $platform_home="${oi4idp::params::platform_home}"

	#platform_install_path_prefix='/opt/platform/idp/'
	#$platform_install_path="${platform_install_path_prefix}${platform_version}"
	$platform_install_path="${oi4idp::params::platform_install_path}"
  
	#$idp_shibboleth_idp_dir_prefix='/shibboleth-idp-'
	$idp_shibboleth_idp_dir_prefix="${oi4idp::params::idp_shibboleth_idp_dir_prefix}"

	#idp_install_path="${platform_install_path}${idp_shibboleth_idp_dir_prefix}${idp_shibboleth_version}"
	# $idp_install_path="${oi4idp::params::}"
	$idp_install_path="${oi4idp::params::idp_install_path}"

	#idp_path="${platform_home}/idp"
	#idp_rpm_name='oi4-idp-'

	#$idp_rpm="${idp_rpm_name}${idp_shibboleth_version}"
	$idp_rpm="${oi4idp::params::idp_rpm}"
  
	#idp_install_script_prefix='/root/shibboleth-idp-'
	$idp_install_script_prefix="${oi4idp::params::idp_install_script_prefix}"
	#idp_install_script_conf_file='/src/installer/resources/build.xml'
	#$idp_install_script="${idp_install_script_prefix}${idp_shibboleth_version}${idp_install_script_conf_file}"
  $idp_install_script="${oi4idp::params::idp_install_script}"

	# Local, dynamic
	$idp_hostname="${oi4idp::params::idp_hostname}"
	$idp_keystore_password= "${oi4idp::params::idp_keystore_password}"

  # should be from Hiera
	#$platform_name=hiera('toas::idp::platform_name')
  #$platform_name="${oi4idp::params::platform_name}"
  #$idp_shibboleth_version="${oi4idp::params::idp_shibboleth_version}"
	$idp_shibboleth_version=hiera('toas::idp::idp_shibboleth_version')
  #$platform_version="${oi4idp::params::platform_version}"
	$platform_version=hiera('toas::idp::platform_version')

	$apacheds_version=hiera('toas::idp::apacheds_version')
	$authn_LDAP_authenticator=hiera('toas::idp::authn_LDAP_authenticator')
	$authn_LDAP_useStartTLS=hiera(toas::idp::authn_LDAP_useStartTLS')
	$authn_LDAP_useSSL=hiera(toas::idp::authn_LDAP_useSSL')
	$authn_LDAP_trustCertificates=hiera(toas::idp::authn_LDAP_trustCertificates')
	$authn_LDAP_trustStore=hiera(toas::idp::authn_LDAP_trustStore')
	$authn_LDAP_returnAttributes=hiera(toas::idp::authn_LDAP_returnAttributes')
	$authn_LDAP_baseDN=hiera(toas::idp::authn_LDAP_baseDN')
	$authn_LDAP_userFilter=hiera(toas::idp::authn_LDAP_userFilter')
	$authn_LDAP_bindDN=hiera(toas::idp::authn_LDAP_bindDN')
	$authn_LDAP_bindDNCredential=hiera(toas::idp::authn_LDAP_bindDNCredential')
	$authn_LDAP_dnFormat=hiera(toas::idp::authn_LDAP_dnFormat')
	$authn_LDAP_ldapURL=hiera(toas::idp::authn_LDAP_ldapURL')
	$authn_LDAP_groupBaseDN=hiera(toas::idp::authn_LDAP_groupBaseDN')
	

	#require openjdkjava
    /* Tomcat which is not run by root user can't listen to pot 443, therefore forwarding of 443 to 8443 */
    exec { "port_forwarding":
		command => "/sbin/iptables -t nat -A PREROUTING -p tcp --dport 443 -j REDIRECT --to-port 8443",
        # execute only if the the redirect rule isnot found
        onlyif => '/sbin/iptables -t nat -L -n -v|grep -r "REDIRECT   tcp .* tcp dpt:443 redir ports 8443" && res=1 || res=0 && test $res = 0'
	} ->

	/* Installs the shibboleth to root home */
	#package { ["${$idp_rpm}"]:
	# 	ensure => installed,
	#	} -> 
	
	/* Modifies ant configuration file with the one from template*/
	file { "${idp_install_script}":
		content => template("oi4idp/build.xml.erb"),
		ensure => present,
		replace => true,
		owner => "root",
		group => "root",
    mode => 0644,
  } ->
	file { "/opt/openinfinity/tomcat/conf/server.xml":
		content => template("oi4idp/server.xml.erb"),
		ensure => present,
		replace => true,
		owner => "root",
		group => "root",
    mode => 0644,
  } ->


    /* The original install.sh with modified ant configuration is used for installation */
	exec { "install_idp":
        #command => "/bin/sh install.sh",
        command => "/root/shibboleth-idp/bin/install.sh",

        # /root/shibboleth-idp/bin/",
        #       command => "/bin/sh ${idp_install_home}",
        #cwd         => "${idp_temp_install_path}",
        #cwd => "/opt/shibboleth-idp/bin/",
        cwd => "/root/shibboleth-idp/bin/",
        #cwd         => "${idp_install_script_prefix}${idp_shibboleth_version}",
        environment => "JAVA_HOME=${java_home}",
        creates => "$idp_install_path/war/idp.war",
        #require => Class["openjdkjava"],
    } ->
	
   file { "${idp_install_path}":
        #content => template("oi4idp/build.xml.erb"),
        ensure => directory,
        recurse => true,
        #replace => true,
        #owner => "${tomcat::install::tomcat_user}",
        owner => "oiuser",
        #group => "${tomcat::install::tomcat_group}",
        mode => 0644,
    } ->
	
	file {"/opt/openinfinity/tomcat/conf/Catalina/":
		ensure => directory,
		owner  => "root",
		group  => "root",
		mode   => 755,
	} ->
	
	file {"/opt/openinfinity/tomcat/conf/Catalina/localhost/":
		ensure => directory,
		owner  => "root",
		group  => "root",
		mode   => 755,
		require => File["/opt/openinfinity/tomcat/conf/Catalina"],
	} ->
	
	file {"/opt/openinfinity/tomcat/conf/Catalina/localhost/idp.xml":
        ensure => present,
        owner => 'oiuser',
        group => 'oiuser',
        mode => 0644,
        source => "puppet:///modules/oi4idp/idp.xml",
		require => File["/opt/openinfinity/tomcat/conf/Catalina/localhost"],
		notify => Service["oi-tomcat"]
	} ->
	
	file {"/opt/shibboleth-idp/webapp/WEB-INF/web.xml":
        ensure => present,
        owner => 'oiuser',
        group => 'oiuser',
        mode => 0644,
        source => "puppet:///modules/oi4idp/web.xml",
		notify => Service["oi-tomcat"]
	} ->
	
	/*file {"/opt/openinfinity/tomcat/conf/server.xml":
        ensure => present,
        owner => 'oiuser',
        group => 'oiuser',
        mode => 0644,
        source => "puppet:///modules/oi4idp/server.xml",
		notify => Service["oi-tomcat"]
	} ->*/
	
	file {"/opt/openinfinity/tomcat/lib/opt":
		ensure => directory,
		owner  => "root",
		group  => "root",
		mode   => 755,
	} ->
	file {"/opt/openinfinity/log/tomcat":
		ensure => directory,
		owner  => "oiuser",
		group  => "oiuser",
		mode   => 755,
	} ->
	file {"/tmp/init-tomcat.sh":
        ensure => present,
        owner => 'oiuser',
        group => 'oiuser',
        mode => 0700,
        source => "puppet:///modules/oi4idp/init-tomcat.sh",
		notify => Service["oi-tomcat"]
	} ->
	exec { "init-tomcat-for-idp":
        command => "/tmp/init-tomcat.sh",
    } ->
	file {"/tmp/setscriptpermissions.sh":
        ensure => present,
        owner => 'root',
        group => 'root',
        mode => 0700,
        source => "puppet:///modules/oi4idp/setscriptpermissions.sh",
		notify => Service["oi-tomcat"]
	} ->
	exec { "/tmp/setscriptpermissions.sh":
        command => "/tmp/setscriptpermissions.sh",
    }


    file {"/opt/openinfinity/common/shibboleth-idp/":
	    ensure => directory,
	    owner  => "root",
	    group  => "root",
	    mode   => 755,  
    } ->    
    file {"/opt/openinfinity/common/shibboleth-idp/add-sp.py":
        ensure => present,
        owner => 'oiuser',
        group => 'oiuser',
        mode => 0777,
        source => "puppet:///modules/oi4idp/add-sp.py"
    }

    file {"/opt/shibboleth-idp/conf/metadata-providers.xml":
        ensure => present,
        owner => 'oiuser',
        group => 'root',
        mode => 0640,
        source => "puppet:///modules/oi4idp/metadata_providers.xml",
    }
    file { "/opt/shibboleth-idp/conf/attribute-resolver.xml":
        source => "puppet:///modules/oi4idp/attribute-resolver.xml",
        ensure => present,
        replace => true,
        owner => "oiuser",
        group => "root",
        mode => 0644,
    } ->
		file { "/opt/shibboleth-idp/conf/attribute-filter.xml":
        source => "puppet:///modules/oi4idp/attribute-filter.xml",
        ensure => present,
        replace => true,
        owner => "oiuser",
        group => "root",
        mode => 0644,
    } -> 
		file { "/opt/shibboleth-idp/conf/ldap.properties":
			content => template("oi4idp/ldap.properties.erb"),
			ensure => present,
			replace => true,
			owner => "oiuser",
			group => "root",
			mode => 0644,
		} 
		
	/* Shibboleth endorsed dir is copied to tomcat home dir */
	#ile { "${platfom_home}/tomcat/endorsed":
        #       ensure => 'directory',
        #       source => "${idp_path}/lib/endorsed",
        #       owner => 'teco',
        #       group => 'teco',
        # ->

	/* Create link for the idp install dir */
    /*file { "idp_link":
		path => "${platform_home}/idp",
        ensure => "link",
       	target => "${idp_install_path}",
		owner => 'teco',
        group => 'teco',
    }*/ 
}
