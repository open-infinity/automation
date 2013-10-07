class oi3-activiti-rdbms::config {
	
	# Directory for activiti schema files
	file { "/opt/openinfinity/3.0.0/activiti/dbschema":
		ensure => directory,
		group => "root",
		owner => "root",
		#require => Class["oi3-mariadb::service"],
		require => Class["oimariadb::service"],
	}
	
	# Activiti schema create scripts
	file { "/opt/openinfinity/3.0.0/activiti/dbschema/activiti.mysql.create.engine.sql":
                ensure => present,
                source => "puppet:///modules/oi3-activiti-rdbms/activiti.mysql.create.engine.sql",
                owner => "root",
                group => "root",
	      #require => Class["oi3-mariadb::service"],
	      require => Class["oimariadb::service"],
                notify => Class["oi3-activiti-rdbms::service"],
        }		
	file { "/opt/openinfinity/3.0.0/activiti/dbschema/activiti.mysql.create.history.sql":
                ensure => present,
                source => "puppet:///modules/oi3-mariadb/activiti.mysql.create.history.sql",
                owner => "root",
                group => "root",
	      #require => Class["oi3-mariadb::service"],
	      require => Class["oimariadb::service"],
                notify => Class["oi3-activiti-rdbms::service"],
        }		
	file { "/opt/openinfinity/3.0.0/activiti/dbschema/activiti.mysql.create.identity.sql":
                ensure => present,
                source => "puppet:///modules/oi3-mariadb/activiti.mysql.create.identity.sql",
                owner => "root",
                group => "root",
	      #require => Class["oi3-mariadb::service"],
	      require => Class["oimariadb::service"],
                notify => Class["oi3-activiti-rdbms::service"],
        }		
	
}
