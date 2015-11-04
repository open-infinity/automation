class profiles::galeracluster {
  $galera_root_password = hiera('toas::galera::root_password')
  $galera_master = hiera('toas::galera::master_address')
  $galera_servers = hiera('toas::galera::server_list')
  $user_mysqld_options = hiera('toas::galera::mysqld_variables')
  $oi_home = hiera('toas::oi_home', '/opt/openinfinity')

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

  class { 'galera':
    galera_servers     => $galeraServers,
    galera_master      => $galera_servers,
    vendor_type        => 'mariadb',
    override_options   => $override_options,
    configure_repo     => false,
    configure_firewall => false,
    root_password      => $galera_root_password,
  }

}

