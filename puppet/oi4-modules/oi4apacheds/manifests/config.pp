class oi4apacheds::config{
  require oi4apacheds::params
  require oi4apacheds::install

  $toas_apacheds_version="${oi4apacheds::params::toas_apacheds_version}"
  $toas_apacheds_servicename="${oi4apacheds::params::toas_apacheds_servicename}"
  $toas_apacheds_admin_pwd="${oi4apacheds::params::toas_apacheds_admin_pwd}"
  $toas_apacheds_master_ip_address="${oi4apacheds::params::toas_apacheds_master_ip_address}"

  exec { "chkconfig_add":
    command   => "/sbin/chkconfig --add $toas_apacheds_servicename",
    user      => "root",
    timeout   => "3600",
    logoutput => true,
  }
  exec { "chkconfig_on":
    command   => "/sbin/chkconfig $toas_apacheds_servicename on",
    user      => "root",
    timeout   => "3600",
    logoutput => true,
    require   => Exec["chkconfig_add"],
  }
  file { "/opt/openinfinity/conf/admin-pwd.ldif":
    content => template("oi4apacheds/admin-pwd.ldif.erb"),
    ensure  => present,
    owner   => "root",
    group   => "root",
    mode    => 0600,
  }
  file { "/opt/openinfinity/conf/set-admin-pwd.sh":
    content => template("oi4apacheds/set-admin-pwd.sh.erb"),
    ensure  => present,
    owner   => "root",
    group   => "root",
    mode    => 0700,
  }
  file { "/opt/openinfinity/conf/replication.ldif.erb":
    content => template("oi4apacheds/replication.ldif.erb}"),
    ensure  => present,
    owner   => "apacheds",
    group   => "apacheds",
    mode    => 0600,
  }
  file { "/opt/openinfinity/conf/set-replication.sh.erb":
    content => template("oi4apacheds/set-replication.sh.erb}"),
    ensure  => present,
    owner   => "apacheds",
    group   => "apacheds",
    mode    => 0700,
  }
}
