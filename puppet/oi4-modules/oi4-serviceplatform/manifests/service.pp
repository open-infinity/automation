class oi4-serviceplatform::service {

        service ["oi-tomcat"] {
                ensure => running,
                hasrestart => true,
                enable => true,
                require => Class["oi4-serviceplatform::config"],
        }
}

