
class oi3snort {
    require oi3-basic

    require oi3snort::install
    require oi3snort::config
    require oi3snort::service
}

class oi3snort::install {
	package { 'oi3-snort':
        ensure => present,
	}
}

class oi3snort::config {
    file {"/opt/openinfinity/conf/snort":
            ensure => directory,
            owner => 'snort',
            group => 'snort',
            mode => 640,
            require => [File["/opt/openinfinity/conf"]],
    }

    file { '/opt/openinfinity/conf/snort/rules-env':
        ensure => present,
        owner => "snort",
        group => "snort",
        mode => 0644,
        content => template("oi3snort/rules-env.erb"),
        require => [File["/opt/openinfinity/conf/snort"]],
    }

    file {"/opt/openinfinity/conf/snort/rules-update.d":
            ensure => directory,
            owner => 'snort',
            group => 'snort',
            mode => 640,
            require => [File["/opt/openinfinity/conf/snort"]],
    }

    file { '/etc/snort/openinfinity.conf':
        ensure => present,
        owner => "snort",
        group => "snort",
        mode => 0644,
        content => template("oi3snort/etc-snort-openinfinity.conf.erb"),
        require => Class["oi3snort::install"],
    }

    file { '/etc/sysconfig/snort':
        ensure => present,
        owner => "snort",
        group => "snort",
        mode => 0644,
        content => template("oi3snort/etc-sysconfig-snort.erb"),
        require => Class["oi3snort::install"],
    }
}

class oi3snort::service {
    service { "oi-snort":
        ensure => running,
        enable => true,
        hasrestart => true,
        subscribe => [
            Package['oi3-snort'],
            File["/etc/snort/openinfinity.conf"],
            File["/etc/sysconfig/snort"],
        ],
    }
}

