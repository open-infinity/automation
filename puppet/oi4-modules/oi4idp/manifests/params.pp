class oi3idp::params {
        include stdlib

	# Static
	$java_home='/usr/lib/jvm/jre'
	$dot='.'
	$platform_home_prefix = "/opt/platform/"
	$platform_home_suffix = "/current"
	$platform_home = "${platform_home_prefix}${platform_name}${platform_home_suffix}"
	$platform_install_path_prefix='/opt/platform/idp/'
	$platform_install_path="${platform_install_path_prefix}${platform_version}"
	$idp_shibboleth_idp_dir_prefix='/shibboleth-idp-'
	$idp_install_path="${platform_install_path}${idp_shibboleth_idp_dir_prefix}${idp_shibboleth_version}"
	$idp_path="${platform_home}/idp"
	$idp_rpm_name='oi3-idp-'
	$idp_rpm="${idp_rpm_name}${idp_shibboleth_version}"
	$idp_install_script_prefix='/root/shibboleth-idp-'
	$idp_install_script_conf_file='/src/installer/resources/build.xml'
	$idp_install_script="${idp_install_script_prefix}${idp_shibboleth_version}${idp_install_script_conf_file}"

	# Dynamic
	$idp_hostname="${::hostname}${dot}${::domain}"
    $idp_keystore_password = fqdn_rand_string(20, 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz1234567890~!@#$%^*_-')

    # Should be from Hiera
	$platform_name='idp'
	$idp_shibboleth_version='2.4.0'
	$platform_version='1.0'
}
