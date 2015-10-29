class oi3-galeralb {
    $cluster_addresses = parsejson($cluster_addresses_array)

    package { "haproxy":
        ensure => installed
    }

    service { "haproxy":
        ensure => running,
        enable => true,
        require => Package["haproxy"],
    }

    file { "/etc/default/haproxy":
        source => "puppet:///modules/oi3-galeralb/haproxydefault",
        require => Package["haproxy"]
    }

    file { "/etc/haproxy/haproxy.cfg":
        content => template("oi3-galeralb/haproxy.cfg.erb"),
        require => Package["haproxy"],
        notify => Service["haproxy"],
    }
}
