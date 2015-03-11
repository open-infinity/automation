
class oi3httpd::config_ssl inherits oi3variables {
    file { "/etc/httpd/conf.d/ssl.conf":
        replace => true,
        owner => "root",
        group => "root",
        mode => 0744,
        content => template("oi3httpd/ssl/ssl.conf.erb"),
        require => File["/opt/openinfinity/common/httpd"],
    }
    
    if $httpd_sscert {
        file { "/opt/openinfinity/common/httpd/script/generate-self-signed-certificate.sh":
            replace => true,
            owner => "root",
            group => "root",
            mode => 0700,
            content => template("oi3httpd/ssl/generate-self-signed-certificate.sh.erb"),
            require => File["/opt/openinfinity/common/httpd/script"],
        }

        exec { "generate-self-signed-certificate.sh":
            command => "/opt/openinfinity/common/httpd/script/generate-self-signed-certificate.sh $httpd_serverkey_password",
            user => "root",
            timeout => "3600",
            notify => Service["$apacheServiceName"],
            require => File["/opt/openinfinity/common/httpd/script/generate-self-signed-certificate.sh"], 
        }

    } else {
        file { "/etc/ssl/certs/$httpd_domain_name.crt":
            replace => true,
            owner => "apache",
            group => "apache",
            mode => 0600,
            content => template("oi3httpd/ssl/ssl-domain.crt.erb"),
            require => Package[$apachePackageName],
        }
        
        file { "/etc/ssl/keys/server.key":
            replace => true,
            owner => "apache",
            group => "apache",
            mode => 0600,
            content => template("oi3httpd/ssl/ssl-server.key.erb"),
            require => Package[$apachePackageName],
        }
     
        file { "/etc/ssl/certs/$httpd_ca_name.crt":
            replace => true,
            owner => "apache",
            group => "apache",
            mode => 0600,
            content => template("oi3httpd/ssl/ssl-ca.crt.erb"),
            require => Package[$apachePackageName],
        }
     
    }
    
}


