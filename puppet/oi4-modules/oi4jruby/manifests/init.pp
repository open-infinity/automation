
class oi3jruby {
    require oi3jruby::install
    require oi3jruby::config
    require oi3jruby::service
}

class oi3jruby::install {
	package { 'oi3-jruby':
        ensure => present,
        require => Class["oi3-basic"],
	}
}

class oi3jruby::config {
}

class oi3jruby::service {
}

