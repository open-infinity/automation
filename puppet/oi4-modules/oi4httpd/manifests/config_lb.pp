
class oi4httpd::config_lb (
	$apacheConfPath = undef
) {
	# Load balancer for a cluster
	file { "${apacheConfPath}oi4-loadbalancer.conf":
		content => template("oi4httpd/lb/oi4-loadbalancer.conf.erb"),
	    replace => true,
	    owner => "root",
	    group => "root",
	    mode => 0644,
	    notify => Service["$apacheServiceName"],
	    require => Package[$apachePackageName],
	}
}

