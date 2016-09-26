class oi4apacheds::postinstall{
  require oi4apacheds::params
  require oi4apacheds::service

  $toas_apacheds_version="${oi4apacheds::params::toas_apacheds_version}"
  $toas_apacheds_master_ip_address="${oi4apacheds::params::toas_apacheds_master_ip_address}"
  $toas_apacheds_node_ip_address="${oi4apacheds::params::toas_apacheds_node_ip_address}"

  exec { "change_password":
    command   => "/opt/openinfinity/conf/set-admin-pwd.sh",
    creates   => "/opt/openinfinity/conf/admin_pwd.txt",
    user      => "root",
    timeout   => "3600",
    logoutput => true,
    require   => Exec["chkconfig_add"],
  }

# NOTE: Partiion for replication can not be created from CLI.
# For that reason it is not possible to automatically create replication,
# since replication is based on partition.
# This script will have to be populated with partition iformation and executed manually.
# Possiblly we could use apacheds API and create a java scrip that would create a partition.
# Once that works, automatic replciation configuration below can be put to use with puppet

  if ($toas_apacheds_master_ip_address != $toas_apacheds_node_ip_address){
    #  exec { "set-replication.sh.erb":
    #    command   => "/opt/openinfinity/scripts/set-replication.sh.erb",
    #    user      => "root",
    #    timeout   => "3600",
    #    logoutput => true,
    #  }
  }
}