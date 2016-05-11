class oi4haproxy($backend_addresses, $srv_timeout="30000", $cli_timeout="60000") {

  package { "haproxy":
		ensure => installed
	}

  service { "haproxy":
		ensure => running,
		enable => true,
		require => Package["haproxy"],
	}

  file { "/etc/haproxy/haproxy.cfg":
	  content => template("loadbalancer/haproxy_jdbc.cfg.erb"),
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
