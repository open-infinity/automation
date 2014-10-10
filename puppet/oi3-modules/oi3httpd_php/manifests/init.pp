
class oi3httpd_php {
    require oi3httpd_php::install
    require oi3httpd_php::config
}

class oi3httpd_php::install inherits oi3variables {
    package { ['php']:
        ensure => present,
        notify => Service[$apacheServiceName],
#        require => Service[$apacheServiceName],
    }

}

class oi3httpd_php::config inherits oi3variables {
    file { '/opt/openinfinity/service/php':
        ensure => "directory",
        owner => 'oiuser',
        group => 'oiuser',
        mode => 0755,
        require => [
            User["oiuser"], 
            File["/opt/openinfinity/service"], # defined in oi3-basic
        ],
    }

    file { '/opt/openinfinity/service/php/conf.d':
        ensure => "directory",
        owner => 'oiuser',
        group => 'oiuser',
        mode => 0755,
        require => [
            User["oiuser"], 
            File["/opt/openinfinity/service/php"], # defined in oi3-basic
        ],
    }

    # A sample file to configure PHP directories with Open Infinity
    file { '/etc/httpd/conf.d/php-openinfinity.conf':
        ensure => present,
        notify => Service[$apacheServiceName],
        content => template("oi3httpd_php/php-openinfinity.conf.erb"),
        require => Package['php'],
    }

# As we don't need any changes to php.ini file, it's better not to manage it
# with Puppet, because that would make appication-specific modifications tricky.
#    file { '/etc/php.ini':
#        ensure => present,
#        notify => Service[$apachedsServiceName],
#        content => template("oi3httpd_php/php.ini.erb"),
#        require => Package['php'],
#    }
    
}

