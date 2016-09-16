class oi4apacheds::service{
  require oi4apacheds::params
  require oi4apacheds::config

  $toas_apacheds_servicename = "${oi4apacheds::params::toas_apacheds_servicename}"

  service { "$toas_apacheds_servicename":
    ensure  => running,
    hasstatus => false,
    enable  => true,
  }
}