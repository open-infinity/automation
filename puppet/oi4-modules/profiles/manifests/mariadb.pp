class profiles::mariadb {
  $mariadb_root_password = hiera('toas::mariadb::root_password')
  $mariadb_backup_password = hiera('toas::mariadb::backup_user_password')
  $user_mysqld_options = hiera('toas::mariadb::mysqld_variables')
  include 'stdlib'

  $local_mysqld_options = {
      'datadir'                 => "$oi_home/data/rdbms",
      'log_error'               => "$oi_home/log/rdbms/rdbms_error.log",
      'slow_query_log'          => '',
      'slow_query_log_file'     => "$oi_home/log/rdbms/rdbms_slow_query.log",
      'general_log_file'        => "$oi_home/log/rdbms/rdbms_general_query.log",
      'log_output'              => 'FILE',
      'pid-file'                => "$oi_home/data/rdbms/mysqld.pid",
      'socket'                  => "$oi_home/data/rdbms/mysql.sock",
      'bind-address'            => '0.0.0.0',
  }

  $local_mysqld_safe_options = {
      'log-error' => "$oi_home/log/rdbms/rdbms_error.log",
      'socket'    => "$oi_home/data/rdbms/mysql.sock",
      'pid-file'  => "$oi_home/data/rdbms/mysqld.pid",
  }
  $local_client_options = {
      'socket' => "$oi_home/data/rdbms/mysql.sock",
  }

  $mysqld_options = merge($user_mysqld_options, $local_mysqld_options)

  $override_options = {
    'mysqld'      => $mysqld_options,
    'mysqld_safe' => $local_mysqld_safe_options,
    'client'      => $local_client_options,
  }
  

  $users = {
    'backup@local'         => {
      ensure                   => 'present',
      max_connections_per_hour => '0',
      max_queries_per_hour     => '0',
      max_updates_per_hour     => '0',
      max_user_connections     => '0',
      password_hash            => mysql_password($mariadb_backup_password),
    },
  }
  $grants = {
    'backup@localhost/*.*' => {
      ensure               => 'present',
      options              => ['GRANT'],
      privileges           => ['SHOW DATABASES', 'SELECT', 'LOCK TABLES', 'RELOAD', 'CREATE', 'DROP', 'DELETE', 'INSERT', 'ALTER'],
      table                => '*.*',
      user                 => 'backup@localhost',
    },
  }
  group { 'mysql':
    ensure => present,
  }->
  user { 'mysql':
    ensure  => present,
    comment => 'MariaDB user',
    gid     => 'mysql',
    shell   => '/bin/false',
  }->
  file {"$oi_home/data/rdbms":
    ensure => directory,
    owner  => 'mysql',
    group  => 'mysql',
    mode   => 0775,
    require => File["$oi_home/data"],
  }->
  file {"$oi_home/log/rdbms":
    ensure  => directory,
    owner   => 'mysql',
    group   => 'mysql',
    mode    => 0775,
    require => File["$oi_home/data"],
  }->
  file {'/var/run/mysql':
    ensure => directory,
    owner  => 'mysql',
    group  => 'mysql',
    mode   => 0775,
  }
 
  class { '::mysql::server':
    root_password           => $mariadb_root_password,
    remove_default_accounts => true,
    override_options        => $override_options,
    package_name            => 'MariaDB-server',
    service_name            => 'mysql',
    mysql_group             => 'mysql',
    users                   => $users,
    grants                  => $grants,
  } -> class {'profiles::mariadbdatabases': 
  }
 
}


