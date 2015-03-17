
class oi3httpd_sp inherits oi3variables  {
	require oi3-basic
	require oi3httpd
	require oi3httpd_sp::install
	require oi3httpd_sp::config
	require oi3httpd_sp::service
}


class oi3httpd_sp::install inherits oi3variables {
    package { "shibboleth":
        ensure => installed,
        require => Package["$apachePackageName"],
    }
}

class oi3httpd_sp::config inherits oi3variables {
    # Service Provider (Shibboleth)
    file { "${apacheConfPath}oi3-shibboleth.conf.toas":
        source => "puppet:///modules/oi3httpd_sp/oi3-shibboleth.conf",
        replace => true,
        owner => "root",
        group => "root",
        mode => 0644,
        notify => Service["$apacheServiceName"],
        require => Package[$apachePackageName],
    }

    file { "${apacheConfPath}oi3-shibboleth-proxy.conf.toas":
        source => "puppet:///modules/oi3httpd_sp/oi3-shibboleth-proxy.conf",
        replace => true,
        owner => "root",
        group => "root",
        mode => 0644,
        notify => Service["$apacheServiceName"],
        require => Package[$apachePackageName],
    }

    file { "/etc/shibboleth/shibboleth2.xml":
        content => template("oi3httpd_sp/sp/shibboleth2.xml.erb"),
        replace => true,
        owner => "root",
        group => "root",
        mode => 0644,
        notify => Service["$apacheServiceName"],
        require => Package["shibboleth"],
    }

    file { "/etc/shibboleth/attribute-map.xml":
        content => template("oi3httpd_sp/sp/attribute-map.xml.erb"),
        replace => true,
        owner => "root",
        group => "root",
        mode => 0644,
        notify => Service["$apacheServiceName"],
        require => Package["shibboleth"],
    }

    file {"/opt/openinfinity/common/shibboleth-sp":
        ensure => directory,
        owner => 'root',
        group => 'root',
        mode => 640,
        require => File["/opt/openinfinity/common"],
    }
    
    file { "/opt/openinfinity/common/shibboleth-sp/configure-sp.sh":
        content => template("oi3httpd_sp/sp/configure-sp.sh.erb"),
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
        notify => Service["shibd"],
        require => [ 
            File["/opt/openinfinity/common/shibboleth-sp/configure-sp.sh"], 
            Package["shibboleth"],
            File["/root/.ssh/id_rsa"]
        ],
    }

    file {"/root/.ssh":
        ensure => directory,
        owner => 'root',
        group => 'root',
        mode => 700,
    }

    # RSA key for accessing IdP machine
    file {"/root/.ssh/id_rsa":
        content => template("oi3httpd_sp/sp/root-id_rsa.erb"),
        replace => true,
        owner => 'root',
        group => 'root',
        mode => 600,
        require => File["/root/.ssh"],
    }

    # RSA key for accessing IdP machine
    file {"/root/.ssh/id_rsa.pub":
        content => template("oi3httpd_sp/sp/root-id_rsa.pub.erb"),
        replace => true,
        owner => 'root',
        group => 'root',
        mode => 600,
        require => File["/root/.ssh"],
    }

}

class oi3httpd_sp::service inherits oi3variables {
    service { "shibd":
        ensure => running,
        enable => true,
        require => Package["shibboleth"]
    }
}

