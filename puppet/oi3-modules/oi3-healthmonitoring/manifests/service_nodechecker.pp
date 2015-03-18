class oi3-healthmonitoring::service_nodechecker {
  service { "oi3-nodechecker":
        ensure     => running,
        hasrestart => true,
        enable     => true,
        require    => Class["oi3-healthmonitoring::config", "oi3-healthmonitoring::service_collectd"], 
      }    
}

