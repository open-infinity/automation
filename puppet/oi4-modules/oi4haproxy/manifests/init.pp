class oi4haproxy($backend_addresses=["127.0.0.1"], $srv_timeout="30000", $cli_timeout="60000") {

  # TODO: check if backend addresses and other class params can go to hiera
  require oi4haproxy::params

  $toas_haproxy_mode=hiera("toas::haproxy::mode", "jdbc")

  package { "haproxy":
		ensure => installed
	}

  service { "haproxy":
		ensure => running,
		enable => true,
		require => Package["haproxy"],
	}

  file { "/etc/haproxy/haproxy.cfg":
	  content => template("oi4haproxy/haproxy.cfg.erb"),
		require => Package["haproxy"],
		notify => Exec['reload-haproxy'],
  }

  exec { 'reload-haproxy':
    command => 'service haproxy reload',
    path => ["/sbin"]
  }

  # Expected by CIS 7.2 Disable System Accounts (Scored)
  exec { 'haproxy-nologin':
    command => '/usr/sbin/usermod -s /sbin/nologin haproxy',
    require => Package["haproxy"],
  }
}
