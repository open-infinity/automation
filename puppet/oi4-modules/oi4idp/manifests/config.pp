class oi4idp::config {
$platform_name = "${tomcat::params::platform_name}"
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
		group => "root" ,
        mode => 0644,
    } ->
        
    notify{" creates $idp_install_path/war/idp.war":
    # ->

    /* The original install.sh with modified ant configuration is used for installation */
	exec { "install_idp":
     	command => "/bin/sh install.sh",
       	cwd         => "${idp_install_script_prefix}${idp_shibboleth_version}",
		environment => "JAVA_HOME=${java_home}",
		creates => "$idp_install_path/war/idp.war",
		#require => Class["openjdkjava"],
    } ->
 
    file { "${idp_install_path}":
		#content => template("oi4idp/build.xml.erb"),
		ensure => directory,
        recurse => true,
        #replace => true,
        owner => "${tomcat::install::tomcat_user}",
        #group => "${tomcat::install::tomcat_group}",
        mode => 0644,
    } ->


	/* Shibboleth endorsed dir is copied to tomcat home dir */
	#ile { "${platfom_home}/tomcat/endorsed":
        #       ensure => 'directory',
        #       source => "${idp_path}/lib/endorsed",
        #       owner => 'teco',
        #       group => 'teco',
        # ->

	/* Create link for the idp install dir */
    file { "idp_link":
		path => "${platform_home}/idp",
        ensure => "link",
       	target => "${idp_install_path}",
		owner => 'teco',
        group => 'teco',
    } 
}
