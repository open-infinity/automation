class profiles::httpd {
  $apachePackageName = hiera('toas::httpd::apachePackageName')
  $apacheServiceName = hiera('toas::httpd::apacheServiceName')
  $use_lb =  hiera('toas::httpd::use_lb', false)
  $apacheConfPath = hiera('toas::httpd::apacheConfPath', undef)
  $httpd_domain_name = hiera('toas::httpd::domain_name') 
  $httpd_selfsigned_certificate = hiera('toas::httpd::selfsigned_certificate', true)
  
  if $httpd_selfsigned_certificate {
	$httpd_serverkey_password = hiera('toas::httpd::serverkey_password')
  }
  
  $httpd_domain_certificate = hiera('toas::httpd::domain_certificate', undef)
  $httpd_ssl_key = hiera('toas::httpd::ssl_key', undef)			
  $httpd_ca_certificate = hiera('toas::httpd::ca_certificate', undef)	

	class {'oi4httpd::install':
			apachePackageName => $apachePackageName
	}-> class {'oi4httpd::config': 
			apachePackageName => $apachePackageName,
			apacheConfPath => $apacheConfPath,
			apacheServiceName => $apacheServiceName,
	}-> class {'oi4httpd::config_ssl': 
			apachePackageName => $apachePackageName,
			apacheServiceName => $apacheServiceName,
			httpd_domain_name => $httpd_domain_name,
			httpd_selfsigned_certificate => $httpd_selfsigned_certificate,
			httpd_serverkey_password => $httpd_serverkey_password, 
			httpd_domain_certificate => $httpd_domain_certificate, 
			httpd_ssl_key => $httpd_ssl_key, 
			httpd_ca_certificate => $httpd_ca_certificate
	}-> class {'oi4httpd::service':
			apachePackageName => $apachePackageName,
			apacheServiceName => $apacheServiceName
	}
	if $use_lb {
		class {'oi4httpd::config_lb': 
			require => Class["oi4httpd::config_ssl"], 
			apacheConfPath => $apacheConfPath
		}
	}
}


