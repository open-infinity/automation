class oi3-oauth-rdbms::service ($toaspathversion = undef, $rdbms_oi_dbuser_password = undef, $rdbms_mysql_password = undef) {
  if $toaspathversion == undef {
    $_toaspathversion = $::toaspathversion
  }
  else {
    $_toaspathversion = $toaspathversion
  }
	if $rdbms_oi_dbuser_password == undef {
		$_rdbms_oi_dbuser_password = $::oi_dbuser_pwd
	}
	else {
		$_rdbms_oi_dbuser_password = $rdbms_oi_dbuser_password
	}
	if $rdbms_mysql_password == undef {
		$_rdbms_mysql_password = $::mysql_password
	}
	else {
		$_rdbms_mysql_password = $rdbms_mysql_password
	}
	exec { "oi3-create-oauth-db-and-schema":
                unless => "/usr/bin/mysql -uroot -p${_rdbms_mysql_password} oauth",
                command => "/usr/bin/mysql -uroot -p${_rdbms_mysql_password} -e \"create database oauth; grant all privileges on oauth.* to
                        'openinfinity'@'%' identified by '${_rdbms_oi_dbuser_password}'; flush privileges; use oauth;  source /opt/openinfinity/$_toaspathversion/oauth/dbschema/oauth2-schema.sql;\"",
		require => Class["oi3-oauth-rdbms::config"],
        }
	
}
