
class oi3httpd inherits oi3variables  {
    require oi3-basic
    require oi3httpd::install
    require oi3httpd::config
    require oi3httpd::service
}

class oi3httpd::install inherits oi3variables {
    package { $apacheInstallPackageNames:
        ensure => installed
    }
}

class oi3httpd::config inherits oi3variables {
    file { "/opt/openinfinity/common/httpd":
        ensure => directory,
        owner => 'apache',
        group => 'apache',
        mode => 640,
        require => [ File["/opt/openinfinity/common"], Package[$apachePackageName] ],
    }
    
    file { "/opt/openinfinity/common/httpd/script":
        ensure => directory,
        owner => 'apache',
        group => 'apache',
        mode => 640,
        require => File["/opt/openinfinity/common/httpd"],
    }

    file { "/etc/httpd/conf.d/ssl.conf":
        replace => true,
        owner => "root",
        group => "root",
        mode => 0744,
        content => template("oi3httpd/ssl.conf.erb"),
        require => File["/opt/openinfinity/common/httpd"],
    }
    
    if $httpd_sscert {
        file { "/opt/openinfinity/common/httpd/script/generate-self-signed-certificate.sh":
            replace => true,
            owner => "root",
            group => "root",
            mode => 0700,
            content => template("oi3httpd/generate-self-signed-certificate.sh.erb"),
            require => File["/opt/openinfinity/common/httpd/script"],
        }

        exec { "generate-self-signed-certificate.sh":
            command => "/opt/openinfinity/common/httpd/script/generate-self-signed-certificate.sh",
            user => "root",
            timeout => "3600",
            notify => Service["$apacheServiceName"],
            require => File["/opt/openinfinity/common/httpd/script/generate-self-signed-certificate.sh"], 
        }

#        file { "/etc/":
#            replace => true,
#            owner => "apache",
#            group => "apache",
#            mode => 0744,
#            content => template("/opt/openinfinity/common/httpd/generate-self-signed-certificate.sh.erb"),
#            require => [ File["/opt/openinfinity/common/httpd"],
#                         Package[$apachePackageName] ],
#        }
        
    } else {
        file { "/etc/ssl/certs/$http_domain_name.crt":
            replace => true,
            owner => "apache",
            group => "apache",
            mode => 0600,
            content => template("oi3httpd/ssl-domain.crt.erb"),
            require => Package[$apachePackageName],
        }
        
        file { "/etc/ssl/keys/server.key":
            replace => true,
            owner => "apache",
            group => "apache",
            mode => 0600,
            content => template("oi3httpd/ssl-server.key.erb"),
            require => Package[$apachePackageName],
        }
     
        file { "/etc/ssl/certs/$http_ca_name.crt":
            replace => true,
            owner => "apache",
            group => "apache",
            mode => 0600,
            content => template("oi3httpd/ssl-ca.crt.erb"),
            require => Package[$apachePackageName],
        }
     
    }
    
}

class oi3httpd::service inherits oi3variables {
    service { $apacheServiceName:
        ensure => running,
        enable => true,
        require => Package[$apachePackageName]
    }

    if ($operatingsystem == 'Ubuntu') {
        exec { '/usr/sbin/a2enmod ssl && /usr/bin/service apache2 restart':
            user => 'root',
            unless => '/usr/sbin/a2query -m ssl',
            require => Package[$apachePackageName],
        }   
    }
}

