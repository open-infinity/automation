class oi4keepalived::service {
  service {"keepalived":
    ensure => running,
    hasrestart => true,
    enable => true,
    hasstatus => false,
    require => Class["oi4keepalived::config"],
  }
}