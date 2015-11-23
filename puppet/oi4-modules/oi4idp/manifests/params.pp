class oi4idp::params {
        include stdlib
	# Should be from Hiera
	$platform_name=hiera('toas::idp::platform_name')
	$platform_version=hiera('toas::idp::platform_version')
	$apacheds_version=hiera('toas::idp::apacheds_version')
	$idp_shibboleth_version=hiera('toas::idp::idp_shibboleth_version')

	# Static
	$java_home='/usr/lib/jvm/jre'
	$dot='.'
	$platform_home_prefix = "/opt/platform/"
	$platform_home_suffix = "/current"
	$platform_home = "${platform_home_prefix}${platform_name}${platform_home_suffix}"
	$platform_install_path_prefix='/opt/shibboleth-idp/'
	$platform_install_path="${platform_install_path_prefix}"
	$idp_shibboleth_idp_dir_prefix='/shibboleth-idp-'
	$idp_install_path="${platform_install_path}${idp_shibboleth_idp_dir_prefix}${idp_shibboleth_version}"
	$idp_path="${platform_home}/idp"
	$idp_rpm_name='oi4-idp-'
	$idp_rpm="${idp_rpm_name}${idp_shibboleth_version}"
	$idp_install_script_prefix='/opt/shibboleth-idp/'
	$idp_install_script_conf_file='/src/installer/resources/build.xml'
	#$idp_install_script="${idp_install_script_prefix}${idp_shibboleth_version}${idp_install_script_conf_file}"
	$idp_install_home="/opt/shibboleth-idp/bin/"
	$idp_install_script="${idp_install_home}/build.xml"
	
	# Dynamic
	$idp_hostname="${::hostname}${dot}${::domain}"
    $idp_keystore_password = fqdn_rand_string(20, 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz1234567890~!@#$%^*_-')

}
