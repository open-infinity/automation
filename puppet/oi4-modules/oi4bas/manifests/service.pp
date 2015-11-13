class oi4bas::service {

    service {"oi-tomcat":
        ensure => running,
        hasrestart => true,
        enable => true,
		hasstatus => false,
        require => Class["oi4bas::config"],
    }
}
