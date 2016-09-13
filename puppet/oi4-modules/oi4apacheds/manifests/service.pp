class oi4apacheds::service{
  require oi4apacheds::config
  require oi4apacheds::params

  $apacheds_version=hiera("toas::apacheds::version", "2.0.0_M17")


}