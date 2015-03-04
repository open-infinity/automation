class oi3httpd_lb_shibboleth inherits oi3variables  {
	require oi3httpd
	require oi3httpd_lb_shibboleth::config
}

class oi3httpd_lb_shibboleth::config inherits oi3variables {
	# Service Provider (Shibboleth)
    if $::spused {
        file { "${apacheConfPath}oi3-shibboleth.conf.toas":
            source => "puppet:///modules/oi3httpd/oi3-shibboleth.conf",
            replace => true,
            owner => "root",
            group => "root",
            mode => 0644,
		    notify => Service["$apacheServiceName"],
            require => Package[$apachePackageName],
        }

		file { "${apacheConfPath}oi3-shibboleth-proxy.conf.toas":
		    source => "puppet:///modules/oi3httpd/oi3-shibboleth-proxy.conf",
		    replace => true,
		    owner => "root",
		    group => "root",
		    mode => 0644,
		    notify => Service["$apacheServiceName"],
		    require => Package[$apachePackageName],
		}
    }

	# Load balancer for a cluster
	if $::portal_addresses {
		file { "${apacheConfPath}oi3-loadbalancer.conf":
			content => template("oi3httpd_lb_shibboleth/oi3-loadbalancer.conf.erb"),
		    replace => true,
		    owner => "root",
		    group => "root",
		    mode => 0644,
		    notify => Service["$apacheServiceName"],
		    require => Package[$apachePackageName],
		}
	}
}

