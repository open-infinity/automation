class profiles::galeracluster {
  $galera_root_password = hiera('toas::galera::root_password')
  $galera_status_password = hiera('toas::galera::status_user_password')
  $galera_master = hiera('toas::galera::master_address')
  $galera_servers = hiera('toas::galera::server_list')
  $user_mysqld_options = hiera('toas::galera::mysqld_variables')
  $oi_home = hiera('toas::oi_home', '/opt/openinfinity')
  $local_interface = hiera('toas::galera::local_interface', 'eth0')

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

  $_mysqld_safe_options = {
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
  
  if ( $local_interface == 'eth0') 
  {
	 class { 'galera':
		galera_servers     => $galera_servers,
		galera_master      => $galera_master,
		vendor_type        => 'mariadb',
		override_options   => $override_options,
		configure_repo     => false,
		configure_firewall => false,
		root_password      => $galera_root_password,
		status_password    => $galera_status_password,
		local_ip => $::ipaddress_eth0,
		require => File["/var/run/mysql"],
	  }-> class {'profiles::mariadbdatabases':}
  } else {
	 class { 'galera':
		galera_servers     => $galera_servers,
		galera_master      => $galera_master,
		vendor_type        => 'mariadb',
		override_options   => $override_options,
		configure_repo     => false,
		configure_firewall => false,
		root_password      => $galera_root_password,
		status_password    => $galera_status_password,
		local_ip => $::ipaddress_eth1,
		require => File["/var/run/mysql"],
	  }-> class {'profiles::mariadbdatabases':}

  }
 
}

