class oi3-rdbms::config ($toaspathversion = undef, $rdbms_innodb_buffer_size = undef) inherits oi3variables {

  if $toaspathversion == undef {
    $_toaspathversion = $::toaspathversion
  }
  else {
    $_toaspathversion = $toaspathversion
  }
  if $rdbms_innodb_buffer_size == undef {
    $_rdbms_innodb_buffer_size = $::innodb_buffer_size
  }
  else {
    $_rdbms_innodb_buffer_size = $rdbms_innodb_buffer_size
  }

    file { '/rdbms_conf':
       path    => $openInfinityConfPath,
       ensure  => present,
       content => template("oi3-rdbms/openinfinity.cnf.erb"),
       owner   => "root",
       group   => "root",
       mode    => 0644,
       require => Class["oi3-rdbms::install"],
    }

    file {"/opt/openinfinity/$_toaspathversion/rdbms/log":
        ensure  => directory,
        owner   => "mysql",
        group   => "mysql",
        mode    => 0755,
        require => Class["oi3-rdbms::install"],
    }

    exec {"create-mysql-database":
       path => "/bin",
       unless => "/usr/bin/test -f /opt/openinfinity/$_toaspathversion/rdbms/data/mysql/user.frm",
       command => $createMysqlDatabaseCommand,
       require => Class["oi3-rdbms::install"],
    }
}
