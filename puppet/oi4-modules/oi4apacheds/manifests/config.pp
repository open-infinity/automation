class oi4apacheds::config{
  require oi4apacheds::params
  $toas_apacheds_version = "${oi4apacheds::params::toas_apacheds_version}"
  $toas_apacheds_pwd="${oi4apacheds::params::toas_apacheds_pwd}"
  $toas_apacheds_master_ip="${oi4apacheds::params::toas_apacheds_master_ip}"
  $toas_apacheds_searchbasedn="${oi4apacheds::params::toas_apacheds_searchbasedn}"

  exec { "chkconfig_add":
    command   => "/sbin/chkconfig -add apacheds-${toas_apacheds_version}-default",
    user      => "root",
    timeout   => "3600",
    logoutput => true,
  }
  exec { "chkconfig_on":
    command   => "/sbin/chkconfig apacheds-${toas_apacheds_version}-default on",
    user      => "root",
    timeout   => "3600",
    logoutput => true,
    require   => Exec["chkconfig_add"],
  }

  # NOTE: See postinstall.pp for explanation why lines below are commented out.

  #  file { "/opt/openinfinity/conf/replication.ldif":
  #    content => template("oi4apacheds/replication.ldif}"),
  #    ensure  => present,
  #    owner   => "apacheds",
  #    group   => "apacheds",
  #    mode    => 0600,
  #  }
  #  file { "/opt/openinfinity/scripts/set-replication.sh":
  #    content => template("oi4apacheds/set-replication.sh}"),
  #    ensure  => present,
  #    owner   => "apacheds",
  #    group   => "apacheds",
  #    mode    => 0700,
  #  }
}
