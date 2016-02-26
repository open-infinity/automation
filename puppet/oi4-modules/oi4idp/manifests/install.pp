class oi4idp::install{
	
		#file {"/tmp/setup_ant_extensions.sh":
		#	ensure => present,
		#	owner => 'root',
		#	group => 'root',
		#	mode => 0700,
		#	source => "puppet:///modules/oi4idp/init.sh",
		#	notify => Service["oi-tomcat"]
		#} ->
		#exec { "/tmp/setupantextensionsforbuild.sh":
		#	command => "/tmp/setup_ant_extensions.sh",
		#}
	
    require oi4idp::params
		#require oi4apacheds
		
		package { "wget":
        ensure => 'installed',
    }->
		package { "ntp":
        ensure => 'installed',
    }
		#package { "apacheds":
		#	ensure => present,
		#}
		
    $idp_rpm="${oi4idp::params::idp_rpm}"
		
		package { "oi4-idp":
      ensure => installed,
    } 
}
	
	
	

