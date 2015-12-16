class oi4shibsp ($ensure = "running", $enable = true, $config = undef) {
	package { "oi4-sp-lb":
		ensure => present
	}

	file { "/etc/shibboleth/shibboleth2.xml.toas":
		content => template($config),
		replace => true,
		owner => "root",
		group => "root",
		mode => 0644,
		require => Package["oi4-sp-lb"]
	}

	service {"shibd":
		ensure => $ensure,
		enable => $enable,
		require => Package["oi4-sp-lb"]
	}
}

class oi4sp ($spclustered = undef, $spmachine = undef)
{
	if $spclustered {
		if $spmachine {
			class {'oi4shibsp':
				ensure => "running",
				enable => true,
				config => "oi4sp/shibboleth2.xml.clustered.erb",
			}
		}
		else {
			class {'oi4shibsp':
				ensure => "stopped",
				enable => false,
				config => "oi4sp/shibboleth2.xml.clustered.erb",
			}
		}
	}
	else {
		class {'oi4shibsp':
			ensure => "running",
			enable => true,
			config => "oi4sp/shibboleth2.xml.single.erb",
		}
	}
}
