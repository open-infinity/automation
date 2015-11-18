class oi4idp::params {
        include stdlib

	# Should be from Hiera
	# Static(?)
	$java_home='/usr/lib/jvm/jre'
	$dot='.'
	$platform_home_prefix = hiera('toas::idp::platform_home_prefix')
	$platform_home_suffix = hiera('toas::idp::platform_home_suffix')
	$platform_home = hiera('toas::idp::platform_home')
	$platform_install_path_prefix=hiera('toas::idp::platform_install_path_prefix')
	$platform_install_path=hiera('toas::idp::platform_install_path')
	$idp_shibboleth_idp_dir_prefix=hiera('toas::idp::idp_shibboleth_idp_dir_prefix')
	$idp_install_path=hiera('toas::idp::idp_install_path')
	$idp_path=hiera('toas::idp::idp_path')
	$idp_rpm_name=hiera('toas::idp::idp_rpm_name')
	$idp_rpm=hiera('toas::idp::idp_rpm')
	$idp_install_script_prefix=hiera('toas::idp::idp_install_script_prefix')
	$idp_install_script_conf_file=hiera('toas::idp::idp_install_script_conf_file')
	$idp_install_script=hiera('toas::idp::idp_install_script')
	$apacheds_rpm=hiera('toas::idp::apacheds_rpm')

	# Dynamic(?)
	$idp_hostname=hiera('toas::idp::idp_hostname')
    $idp_keystore_password = hiera('toas::idp::idp_keystore_password')

    
	$platform_name=hiera('toas::idp::platform_name')
	$idp_shibboleth_version=hiera('toas::idp::idp_shibboleth_version')
	$platform_version=hiera('toas::idp::platform_version')
	$apacheds_version=hiera('toas::idp::apacheds_version')
}
