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

class oi4httpd::config
(
  $apachePackageName = undef,
  $apacheConfPath = undef,
  $apacheServiceName = undef,
  $use_ajp_proxy = undef,
) {
  require oi4httpd::install
  file { "/opt/openinfinity/common/httpd":
    ensure  => directory,
    owner   => 'apache',
    group   => 'apache',
    mode    => 640,
    require => [ File["/opt/openinfinity/common"], Package[$apachePackageName] ],
  }

  file { "/opt/openinfinity/common/httpd/script":
    ensure  => directory,
    owner   => 'apache',
    group   => 'apache',
    mode    => 640,
    require => File["/opt/openinfinity/common/httpd"],
  }

  if ($use_ajp_proxy == true){
    file { "${apacheConfPath}oi4-ajp-proxy.conf":
      source  => "puppet:///modules/oi4httpd/oi4-ajp-proxy.conf",
      replace => true,
      owner   => "root",
      group   => "root",
      mode    => 0644,
      notify  => Service["$apacheServiceName"],
      require => Package[$apachePackageName],
    }
  }
}

class oi4httpd::service
(
  $apachePackageName = undef,
  $apacheServiceName = undef
) {
  service { $apacheServiceName:
    ensure  => running,
    enable  => true,
    require => Package[$apachePackageName]
  }
}

