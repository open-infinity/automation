class oi4os {
        $etc_hosts_additions=hiera('toas::os::etc_hosts_additions', undef)

        file { '/root/append_to_etc_hosts.sh':
                content => template("oi4os/append_to_etc_hosts.sh.erb"),
                ensure => present,
                replace => true,
                owner => "root",
                group => "root",
                mode => 0700,
        } ->
        exec { 'append_to_etc_hosts':
                command => "/root/append_to_etc_hosts.sh",
                user    => 'root',
                group   => 'root',
        }
}
