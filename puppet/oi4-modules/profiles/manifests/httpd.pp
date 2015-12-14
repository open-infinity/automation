class profiles::serviceplatform {
  $apachePackageName = hiera('toas::httpd::apachePackageName')
  $apacheServiceName = hiera('toas::httpd::apacheServiceName')
  $use_lb =  hiera('toas::httpd::use_lb', undef)
  $apacheConfPath = hiera('toas::httpd::apacheConfPath', undef)

class {'oi4httpd::install':
		apachePackageName => $apachePackageName
}-> class {'oi4httpd::config': 
		apachePackageName => $apachePackageName
}-> class {'oi4-serviceplatform::service':
		apachePackageName => $apachePackageName,
		apacheServiceName => $apacheServiceName
}-> class {'oi4httpd::config_ssl': 
		apachePackageName => $apachePackageName,
}
	if $use_lb {
		class {'oi4httpd::config_lb': 
			require => Class["oi4httpd::config_ssl"], 
			apacheConfPath => $apacheConfPath
		}
	}
}


