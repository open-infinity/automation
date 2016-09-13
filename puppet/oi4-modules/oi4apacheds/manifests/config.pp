class oi4apacheds::config{
  require oi4apacheds::install
  require oi4apacheds::params

  $toas_apacheds_version = "${oi4apacheds::params::toas_apacheds_version}"

  file { "/opt/openinfinity/conf/replication.ldif":
    content => template("oi4apacheds/replication.ldif}"),
    ensure  => present,
    owner   => "apacheds",
    group   => "apacheds",
    mode    => 0600,
  }
  file { "/opt/openinfinity/scripts/set-replication.sh":
    content => template("oi4apacheds/set-replication.sh}"),
    ensure  => present,
    owner   => "apacheds",
    group   => "apacheds",
    mode    => 0700,
  }
  exec { "set-replication.sh":
    command => "/opt/openinfinity/scripts/set-replication.sh",
    user => "root",
    timeout => "3600",
    logoutput => true,
    require => [
      File["/opt/openinfinity/scripts/set-replication.sh"],
      File["/opt/openinfinity/conf/replication.ldif"],
    ],
  }
}
