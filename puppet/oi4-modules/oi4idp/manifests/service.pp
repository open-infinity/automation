class oi4idp::service {
  require oi4idp::config

  service {"memcached":
    ensure => running,
    hasrestart => true,
    enable => true,
    hasstatus => true,
  }
}

class oi4idp::tomcat_service {
  service {"oi-tomcat-service":
    ensure => running,
    hasrestart => true,
    enable => true,
  }
}