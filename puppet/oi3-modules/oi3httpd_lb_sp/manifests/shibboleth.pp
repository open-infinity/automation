
class oi3httpd_shibboleth::install inherits oi3variables {
    package { "shibboleth":
        ensure => installed,
        require => Package["$apachePackageName"],
    }
}

class oi3httpd_shibboleth::config inherits oi3variables {
    # Service Provider (Shibboleth)
    file { "${apacheConfPath}oi3-shibboleth.conf.toas":
        source => "puppet:///modules/oi3httpd_lb_shibboleth/oi3-shibboleth.conf",
        replace => true,
        owner => "root",
        group => "root",
        mode => 0644,
        notify => Service["$apacheServiceName"],
        require => Package[$apachePackageName],
    }

    file { "${apacheConfPath}oi3-shibboleth-proxy.conf.toas":
        source => "puppet:///modules/oi3httpd_lb_shibboleth/oi3-shibboleth-proxy.conf",
        replace => true,
        owner => "root",
        group => "root",
        mode => 0644,
        notify => Service["$apacheServiceName"],
        require => Package[$apachePackageName],
    }

    file { "/etc/shibboleth/shibboleth2.xml":
        content => template("oi3httpd_lb_shibboleth/sp/shibboleth2.xml.erb"),
        replace => true,
        owner => "root",
        group => "root",
        mode => 0644,
        notify => Service["$apacheServiceName"],
        require => Package["shibboleth"],
    }

    file { "/etc/shibboleth/attribute-map.xml":
        content => template("oi3httpd_lb_shibboleth/sp/attribute-map.xml.erb"),
        replace => true,
        owner => "root",
        group => "root",
        mode => 0644,
        notify => Service["$apacheServiceName"],
        require => Package["shibboleth"],
    }

    file {"/opt/openinfinity/common/shibboleth-sp":
        ensure => directory,
        owner => 'snort',
        group => 'snort',
        mode => 640,
        require => File["/opt/openinfinity/common"],
    }
    
    file { "/opt/openinfinity/common/shibboleth-sp/configure-sp.sh":
        content => template("oi3httpd_lb_shibboleth/sp/configure-sp.sh.erb"),
        replace => true,
        owner => "root",
        group => "root",
        mode => 0744,
        require => File["/opt/openinfinity/common/shibboleth-sp"],
    }

    exec { "configure-sp.sh":
        command => "/opt/openinfinity/common/shibboleth-sp/configure-sp.sh",
        user => "root",
        timeout => "3600",
        notify => Service["$apacheServiceName"],
        require => [ 
            File["/opt/openinfinity/common/shibboleth-sp/configure-sp.sh"], 
            Package["shibboleth"] 
        ],
    }

}

