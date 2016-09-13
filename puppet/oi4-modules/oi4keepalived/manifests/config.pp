class oi4keepalived::config {

  require oi4keepalived::install
  require oi4keepalived::params

  $keepalived_interface = "${oi4keepalived::params::toas_keepalived_interface}"
  $keepalived_virtual_router_id = "${oi4keepalived::params::toas_keepalived_virtual_router_id}"
  $keepalived_priority = "${oi4keepalived::params::toas_keepalived_priority}"
  $keepalived_virtual_ipaddress = "${oi4keepalived::params::toas_keepalived_virtual_ipaddres}"
  $keepalived_track_script = "${oi4keepalived::params::toas_keepalived_track_script}"
  $keepalived_vrrp_unicast_bind = "${oi4keepalived::params::toas_keepalived_vrrp_unicast_bind}"
  $keepalived_vrrp_unicast_peer = "${oi4keepalived::params::toas_keepalived_vrrp_unicast_peer}"
  
  file { "/etc/keepalived/keepalived.conf":
    content => template("oi4keepalived/keepalived.conf.erb}",
    ensure  => present,
    replace => true,
    owner   => "root",
    group   => "root",
    mode    => 0600,
  }
  file { "/opt/keepalived/master.sh":
    ensure => present,
    owner  => 'root',
    group  => 'root',
    mode   => 0700,
    source => "puppet:///modules/oi4keepalived/master.sh"
  }
}