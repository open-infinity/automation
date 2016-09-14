class oi4idp::install{
  require oi4idp::params
  $requires_ntp="${oi4idp::params::requires_ntp}"
  $idp_rpm="${oi4idp::params::idp_rpm}"

  if ($requires_ntp == true){
    package { "ntp":
      ensure => 'installed',
    }
  }
  package { "${$idp_rpm}":
    ensure => installed,
  }
  package { "wget":
    ensure => 'installed',
  }
}




