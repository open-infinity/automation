
class oi4httpd::config_lb (
	$jvm_routes = undef,
	$backend_addresses = undef,
	$apacheServiceName= undef,
	$apachePackageName = undef,
	$apacheConfPath = undef,
) {
  require oi4httpd::install
	# Use $jvm_routes for load balancing. Tomcat must set up cookies with the same name
	#	Route name should be unique for each balanced machine
	if ($jvm_routes == undef){
		$with_routes = ""
	}
	else {
		$with_routes = "-with-routes"
	}

	# Load balancer for a cluster
	file { "${apacheConfPath}oi4-loadbalancer.conf":
		content => template("oi4httpd/lb/oi4-loadbalancer$with_routes.conf.erb"),
		replace => true,
		owner   => "root",
		group   => "root",
		mode    => 0644,
		notify  => Service["$apacheServiceName"],
		require => Package[$apachePackageName],
	}

}

