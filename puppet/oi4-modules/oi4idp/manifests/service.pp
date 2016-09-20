class oi4idp::service {
  require oi4idp::config

  service {"memcached":
    ensure => running,
    hasrestart => true,
    enable => true,
    hasstatus => true,
  }
}