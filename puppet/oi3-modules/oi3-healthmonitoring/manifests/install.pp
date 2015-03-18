class oi3-healthmonitoring::install {
  #package { ["Pound"]:
  #      ensure => installed,
	#require => Class["oi3-basic"]
  #  }
    package { ["oi3-nodechecker"]:
        ensure => latest,
	require => Class["oi3-basic"]
    }
    package { ["collectd"]:
        ensure => installed,
        require => Class["oi3-basic"]
    }
    #package { ["oi3-rrd-http-server"]:
    #    ensure => installed,
    #    require => Class["oi3-basic"]
    #}
}

