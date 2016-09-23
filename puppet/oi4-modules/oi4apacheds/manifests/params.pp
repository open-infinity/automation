class oi4apacheds::params{
  $toas_apacheds_version=hiera("toas::apacheds::version", "2.0.0_M17-1")
  $toas_apacheds_servicename=hiera("toas::apacheds::servicename")
  $toas_apacheds_admin_pwd=hiera("toas::apacheds::admin_pwd")
  $toas_apacheds_master_ip=hiera("toas::apacheds::master_ip")
  $toas_apacheds_replication_base_dn=hiera("toas::apacheds::replication_base_dn", "ou=users,o=toas")

  #  NOTE: See postinstall.pp for explanation why lines below are commented out.
#  $toas_apacheds_master_ip=hiera("toas::apacheds::master_ip")
#  $toas_apacheds_searchbasedn=hiera("toas::apacheds::searchbasedn")
}


