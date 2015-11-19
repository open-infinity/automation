class oi4bas::service ($run_tomcat = true) {
	if $run_tomcat {
		service {"oi-tomcat":
			ensure => running,
			hasrestart => true,
			enable => true,
			hasstatus => false,
			require => Class["oi4bas::config"],
		}
	}
}
