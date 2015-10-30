class oi3-portal-rdbms::service ($rdbms_mysql_password = undef, $portal_db_password = undef) {

  if $rdbms_mysql_password == undef {
    $_rdbms_mysql_password = $::mysql_password
  }
  else {
    $_rdbms_mysql_password = $rdbms_mysql_password
  }
  if $portal_db_password == undef {
    $_portal_db_password = $::portal_db_password
  }
  else {
    $_portal_db_password = $portal_db_password
  }
	exec { "oi3-create-portal-db":
		unless => "/usr/bin/mysql -uroot -p$_rdbms_mysql_password lportal",
		command => "/usr/bin/mysql -uroot -p$_rdbms_mysql_password -e \"create database lportal; grant all privileges on lportal.* to
			'liferay'@'%' identified by '$_portal_db_password'; flush privileges;\"",
		require => Class["oi3-rdbms::service"],
	}

}
