
class oi3jror {
    require oi3jror::install
    require oi3jror::config
    require oi3jror::service
}

class oi3jror::install {
	# Ruby on Rails
	exec { 'jgem-install-rails':
		command => "jgem install rails -v 4.1.6",
		path    => "/bin:/usr/bin:/opt/openinfinity/3.2.0/jruby/bin",
		logoutput => true,
        require => Package["oi3-jruby"],
	}

	# ActiveRecord/JDBC-MySQL adapter	
	exec { 'jgem-install-jdbcmysql':
		command => "jgem install activerecord-jdbcmysql-adapter",
		path    => "/bin:/usr/bin:/opt/openinfinity/3.2.0/jruby/bin",
		logoutput => true,
        require => Exec["jgem-install-rails"],
	}

	# OpenSSL support
	exec { 'jgem-install-openssl':
		command => "jgem install jruby-openssl",
		path    => "/bin:/usr/bin:/opt/openinfinity/3.2.0/jruby/bin",
		logoutput => true,
        require => Exec["jgem-install-jdbcmysql"],
	}

	# Warbler to server-side too
	exec { 'jgem-install-warbler':
		command => "jgem install warbler",
		path    => "/bin:/usr/bin:/opt/openinfinity/3.2.0/jruby/bin",
		logoutput => true,
        require => Exec["jgem-install-openssl"],
	}

	# MongoDB support
	# See: http://docs.mongodb.org/ecosystem/tutorial/getting-started-with-ruby-on-rails-3/
	exec { 'jgem-install-mongo':
		command => "jgem install mongo_mapper",
		path    => "/bin:/usr/bin:/opt/openinfinity/3.2.0/jruby/bin",
		logoutput => true,
        require => Exec["jgem-install-warbler"],
	}

	# ExecJS support
	exec { 'jgem-install-execjs':
		command => "jgem install execjs",
		path    => "/bin:/usr/bin:/opt/openinfinity/3.2.0/jruby/bin",
		logoutput => true,
        require => Exec["jgem-install-mongo"],
	}

}

class oi3jror::config {
}

class oi3jror::service {
}

