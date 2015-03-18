class oi3-healthmonitoring::service_collectd {
  service { "collectd":
		ensure => running,
		hasrestart => true,
		enable => true,
		require => Class["oi3-healthmonitoring::config"],
	}    
}


