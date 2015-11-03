class oi4bas::service {

    service {"oi-tomcat":
        ensure => running,
        hasrestart => true,
        enable => true,
        require => Class["oi4bas::config"],
    }
}
