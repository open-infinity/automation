class oi3-activiti-rdbms::config ($toaspathversion = undef, $rdbms_oi_httpuser_pwd = undef) {
	if $toaspathversion == undef {
    $_toaspathversion = $::toaspathversion
  }
  else {
    $_toaspathversion = $toaspathversion
  }
  if $rdbms_oi_httpuser_pwd == undef {
		$_rdbms_oi_httpuser_pwd = $::oi_httpuser_pwd
	}
	else {
		$_rdbms_oi_httpuser_pwd = $rdbms_oi_httpuser_pwd
	}
	# Directory for activiti schema files
	file { "/opt/openinfinity/$_toaspathversion/activiti":
		ensure => directory,
		group => "root",
		owner => "root",
		require => Class["oi3-rdbms::service"],
	}

	# Directory for activiti schema files
	file { "/opt/openinfinity/$_toaspathversion/activiti/dbschema":
		ensure => directory,
		group => "root",
		owner => "root",
		require => File["/opt/openinfinity/$_toaspathversion/activiti"],
	}

	# Activiti schema create scripts
	file { "/opt/openinfinity/$_toaspathversion/activiti/dbschema/activiti.mysql.create.engine.sql":
                ensure => present,
                source => "puppet:///modules/oi3-activiti-rdbms/activiti.mysql.create.engine.sql",
                owner => "root",
                group => "root",
	      require => Class["oi3-rdbms::service"],
                notify => Class["oi3-activiti-rdbms::service"],
        }
	file { "/opt/openinfinity/$_toaspathversion/activiti/dbschema/activiti.mysql.create.history.sql":
                ensure => present,
                source => "puppet:///modules/oi3-activiti-rdbms/activiti.mysql.create.history.sql",
                owner => "root",
                group => "root",
	      require => Class["oi3-rdbms::service"],
                notify => Class["oi3-activiti-rdbms::service"],
        }
	file { "/opt/openinfinity/$_toaspathversion/activiti/dbschema/activiti.mysql.create.identity.sql":
                ensure => present,
                source => "puppet:///modules/oi3-activiti-rdbms/activiti.mysql.create.identity.sql",
                owner => "root",
                group => "root",
	      require => Class["oi3-rdbms::service"],
                notify => Class["oi3-activiti-rdbms::service"],
        }
	file { "/opt/openinfinity/$_toaspathversion/activiti/dbschema/activiti.mysql.add.oiuser.sql":
                ensure => present,
                owner => "root",
                group => "root",
                content => template("oi3-activiti-rdbms/activiti.mysql.add.oiuser.sql.erb"),
	      require => Class["oi3-rdbms::service"],
                notify => Class["oi3-activiti-rdbms::service"],
        }

}

