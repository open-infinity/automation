class oi4keepalived::params {
  $keepalived_interface = hiera("toas::keepalived::interface")
  $keepalived_virtual_router_id = hiera("toas::keepalived::virtual_router_id")
  $keepalived_priority = hiera("toas::keepalived::priority")
  $keepalived_virtual_ipaddress = hiera("toas::keepalived::virtual_ipaddres")
  $keepalived_track_script = hiera("toas::keepalived::track_script")
  $keepalived_vrrp_unicast_bind = hiera("toas::keepalived::vrrp_unicast_bind")
  $keepalived_vrrp_unicast_peer = hiera("toas::keepalived::vrrp_unicast_peer")
}

