class oi3idp::params {
        include stdlib

	# Static
	$java_home='/usr/lib/jvm/jre'
	$dot='.'
	$platform_home_prefix = hiera('toas::idp::platform_home_prefix')
	$platform_home_suffix = hiera('toas::idp::platform_home_prefix')
	$platform_home = hiera('toas::idp::platform_home_prefix')
	$platform_install_path_prefix=hiera('toas::idp::platform_home_prefix')
	$platform_install_path=hiera('toas::idp::platform_home_prefix')
	$idp_shibboleth_idp_dir_prefix=hiera('toas::idp::platform_home_prefix')
	$idp_install_path=hiera('toas::idp::platform_home_prefix')
	$idp_path=hiera('toas::idp::platform_home_prefix')
	$idp_rpm_name=hiera('toas::idp::platform_home_prefix')
	$idp_rpm=hiera('toas::idp::platform_home_prefix')
	$idp_install_script_prefix=hiera('toas::idp::platform_home_prefix')
	$idp_install_script_conf_file=hiera('toas::idp::platform_home_prefix')
	$idp_install_script=hiera('toas::idp::platform_home_prefix')
	$apacheds_rpm=hiera('toas::idp::platform_home_prefix')

	# Dynamic
	$idp_hostname=hiera('toas::idp::platform_home_prefix')
    $idp_keystore_password = hiera('toas::idp::platform_home_prefix')

    # Should be from Hiera
	$platform_name=hiera('toas::idp::platform_home_prefix')
	$idp_shibboleth_version=hiera('toas::idp::platform_home_prefix')
	$platform_version=hiera('toas::idp::platform_home_prefix')
	${apacheds_version}=hiera('toas::idp::platform_home_prefix')
}
