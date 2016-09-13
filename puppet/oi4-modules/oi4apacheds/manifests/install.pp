class oi4apacheds::install{
	require oi4apacheds::params
	$toas_apacheds_version = "${oi4apacheds::params::toas_apacheds_version}"

	package { ["java-1.8.0-openjdk"]:
		ensure => present
	}
	package { "apacheds":
		ensure => "${toas_apacheds_version}",
	}
}
	
	
	

