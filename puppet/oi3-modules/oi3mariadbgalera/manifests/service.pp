class oi3oi3mariadbgalera::service ($rdbms_mysql_password = undef) {

# only initial start can be automated. bootstrap requires manual check for most advenced node
# need to read memberId in init. need to verify installation before start
# need to verify if initial start (e.g. no data files yet)
  if $_memberid == 1 {

        service { "mysql":
                ensure => running,
	      flags => "--wsrep-new-cluster",
                hasstatus => true,
                hasrestart => true,
                enable => true,
	      unless => '/opt/openinfinity/current/rdbms/data/mysql/user.MYI',
                require => require => [File["/opt/openinfinity/current/rdbms/data/mysql/user.frm"],
        }

  } else {
        service { "mysql":
                ensure => running,
                hasstatus => true,
                hasrestart => true,
                enable => true,
	      unless => '/opt/openinfinity/current/rdbms/data/mysql/user.MYI',
                require => require => [File["/opt/openinfinity/current/rdbms/data/mysql/user.frm"],
        }
  }

}
