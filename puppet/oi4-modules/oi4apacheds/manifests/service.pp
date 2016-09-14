class oi4apacheds::service{
  require oi4apacheds::params
  $toas_apacheds_version = "${oi4apacheds::params::toas_apacheds_version}"

  service { "apacheds-${toas_apacheds_version}-default":
    ensure  => running,
    enable  => true,
  }
}