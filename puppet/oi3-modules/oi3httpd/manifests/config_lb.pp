
class oi3httpd::config_lb inherits oi3variables {
	# Load balancer for a cluster
	file { "${apacheConfPath}oi3-loadbalancer.conf":
		content => template("oi3httpd/lb/oi3-loadbalancer.conf.erb"),
	    replace => true,
	    owner => "root",
	    group => "root",
	    mode => 0644,
	    notify => Service["$apacheServiceName"],
	    require => Package[$apachePackageName],
	}
}

