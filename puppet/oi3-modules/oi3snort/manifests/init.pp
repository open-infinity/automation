
class oi3snort {
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

