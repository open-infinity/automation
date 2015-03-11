
class oi3httpd inherits oi3variables  {
    require oi3-basic
    require oi3httpd::install
    require oi3httpd::config
    require oi3httpd::config_ssl
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

