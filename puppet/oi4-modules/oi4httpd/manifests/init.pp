class oi4httpd 
{
}

class oi4httpd::install 
(
  $apachePackageName = undef
)
{
	$apacheInstallPackageNames = [$apachePackageName, 'mod_ssl']
	
    package { $apacheInstallPackageNames:
        ensure => installed
    }
}

class oi4httpd::config {
(
  $apachePackageName = undef
)
    file { "/opt/openinfinity/common/httpd":
        ensure => directory,
        owner => 'apache',
        group => 'apache',
        mode => 640,
        require => [ File["/opt/openinfinity/common"], Package[$apachePackageName] ],
    }

    file { "/opt/openinfinity/common/httpd/script":
        ensure => directory,
        owner => 'apache',
        group => 'apache',
        mode => 640,
        require => File["/opt/openinfinity/common/httpd"],
    }
}
    
class oi4httpd::service {
(
  $apachePackageName = undef,
  $apacheServiceName = undef
)
    service { $apacheServiceName:
        ensure => running,
        enable => true,
        require => Package[$apachePackageName]
    } 
}

