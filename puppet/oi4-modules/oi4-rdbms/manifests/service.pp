class oi3-rdbms::service ($rdbms_mysql_password = undef) {
	if $rdbms_mysql_password == undef {
		$_rdbms_mysql_password = $::mysql_password
	}
	else {
		$_rdbms_mysql_password = $rdbms_mysql_password
	}

        service { "mysql":
                ensure => running,
                hasstatus => true,
                hasrestart => true,
                enable => true,
                require => Class["oi3-rdbms::config"],
        }

        exec { "set-mariadb-password":
                unless => "/usr/bin/mysqladmin -uroot -p${_rdbms_mysql_password} status",
                command => "/usr/bin/mysqladmin -uroot password ${_rdbms_mysql_password}",
                require => Service["mysql"],
        }

        exec { "create-backup-user":
                unless => "/usr/bin/mysql -ubackup -ptoasbackup",
                command => "/usr/bin/mysql -uroot -p${_rdbms_mysql_password} -e \"grant show databases, select, lock tables, reload, create, drop, delete, insert, alter on *.* to backup@localhost identified by 'toasbackup'; flush privileges;\"",
                require => Exec["set-mariadb-password"],
        }

	exec { "delete-anonymous-users":
		onlyif => "/usr/bin/mysql -uroot -p${_rdbms_mysql_password} -e \"select '1' from mysql.user where user = '';\"",
		command => "/usr/bin/mysql -uroot -p${_rdbms_mysql_password} -e \"delete from mysql.user where user = '';\"",
		require => Exec["set-mariadb-password"],
	}
}
