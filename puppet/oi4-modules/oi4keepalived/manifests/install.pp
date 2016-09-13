class oi4keepalived::install {
  package { "keepalived":
    # Requires keepalived-1.1.13 or greater
    ensure => present,
  }
}
