class oi3httpd inherits oi3variables  {
    package { $apacheInstallPackageNames:
        ensure => installed
    }

    if ($operatingsystem == 'Ubuntu') {
        exec { '/usr/sbin/a2enmod ssl && /usr/bin/service apache2 restart':
            user => 'root',
            unless => '/usr/sbin/a2query -m ssl',
            require => Package[$apachePackageName],
        }   
    }

    service { $apacheServiceName:
        ensure => running,
        enable => true,
        require => Package[$apachePackageName]
    }
}

