class oi4os::config (
)  {
	$etc_hosts_additions=hiera('toas::os::etc_hosts_additions', undef)
	file_line { 'Append a line to /etc/hosts':
		path  => '/etc/hosts', 
		line => $etc_hosts_additions,
	}
}

