
class oi3nodejs {
    require oi3nodejs::install
    require oi3nodejs::config
    require oi3nodejs::service
}

class oi3nodejs::install {
	# Node.js
	package { 'nodejs':
        ensure => present,
	}
	
	# Node Package Manager
	package { 'npm':
        ensure => present,
	}

	# MySQL driver
	exec { 'install-nodejs-mysql':
		command => "npm install node-mysql",
		path    => "/bin:/usr/bin",
        require => Package["npm"],
	}
	
	# MongoDB driver
	exec { 'npm install mongodb':
		command => "npm install mongodb",
		path    => "/bin:/usr/bin",
        require => Package["npm"],
	}
	
}

class oi3nodejs::config {
}

class oi3nodejs::service {
}

