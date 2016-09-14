class oi4apacheds::params{
  $toas_apacheds_version=hiera("toas::apacheds::version", "2.0.0_M17")

#  NOTE: See postinstall.pp for explanation why lines below are commented out.
#  $toas_apacheds_pwd=hiera("toas::apacheds::pwd")
#  $toas_apacheds_master_ip=hiera("toas::apacheds::master_ip")
#  $toas_apacheds_searchbasedn=hiera("toas::apacheds::searchbasedn")
}


