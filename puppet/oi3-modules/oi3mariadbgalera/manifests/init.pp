class oi3mariadbgalera ($rdbms_mysql_password = undef, $galera_cluster_address = undef, $galera_node_address = undef, $galera_node_name = undef) inherits oi3variables {
  if $rdbms_mysql_password == undef {
    $_rdbms_mysql_password = $::mysql_password
  }
  else {
    $_rdbms_mysql_password = $rdbms_mysql_password
  }
  if $galera_cluster_address == undef {
    $_galera_cluster_address = $::galera_cluster_address
  }
  else {
    $_galera_cluster_address = $galera_cluster_address
  }
  if $galera_node_address == undef {
    $_galera_node_address = $::galera_node_address
  }
  else {
    $_galera_node_address = $galera_node_address
  }
  if $galera_node_name == undef {
    $_galera_node_name = $::galera_node_name
  }
  else {
    $_galera_node_name = $galera_node_name
  }

  ensure_resource('user', 'mysql', {
        home => "/opt/openinfinity/3.1.0/rdbms/data",
        managehome => false,
        system => true,
        gid => 'mysql',
        before => Package['oi3-mariadb-galera'],
    })

    ensure_resource('group', 'mysql', {
        ensure => present
    })

    package { "oi3-mariadb-galera":
        ensure => present,
    }

    if ($operatingsystem ==  'CentOS') or ($operatingsystem == 'RedHat') {
    package { "nc":
        ensure => present,
        before => file["/opt/openinfinity/3.1.0/rdbms"],
        }
    }

    file {"/opt/openinfinity/3.1.0/rdbms":
        ensure => directory,
        owner => "mysql",
        group => "mysql",
        mode => 0775,
        require => file["/opt/openinfinity/3.1.0"],
    } ->
    file {"/opt/openinfinity/3.1.0/rdbms/data":
        ensure => directory,
        owner => "mysql",
        group => "mysql",
        mode => 0775,
    } ->
    file {$openInfinityConfPath:
        ensure => present,
        content => template("oi3mariadbgalera/server_my.cnf.erb"),
        owner => "root",
        group => "root",
        mode => 0644,
    } ->
    file {"/root/mysql_system_tables_data.sql":
        ensure => present,
        content => template("oi3mariadbgalera/mysql_system_tables_data.sql.erb"),
        owner => "root",
        group => "root",
        mode => 0640,
    } ->
    file {"/root/mysql_install_db":
        ensure => present,
        source => "puppet:///modules/oi3mariadbgalera/mysql_install_db",
        owner => "root",
        group => "root",
        mode => 0750,
    } ->
    exec {"create-mysql-database":
        creates => "/opt/openinfinity/3.1.0/rdbms/data/mysql/user.frm",
        command => $createMariaDbDatabaseCommand,
    } 
}
