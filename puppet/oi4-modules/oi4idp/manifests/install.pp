class oi4idp::install{
	
        #package { ["java-1.7.0-openjdk"]:
        	#ensure => present,
                #TODO maybe needed for logrotate ect
        
	#}
		file {"/tmp/setup_ant_extensions.sh":
			ensure => present,
			owner => 'root',
			group => 'root',
			mode => 0700,
			source => "puppet:///modules/oi4idp/init.sh",
			notify => Service["oi-tomcat"]
		} ->
		exec { "/tmp/setupantextensionsforbuild.sh":
			command => "/tmp/setup_ant_extensions.sh",
		}
	
	
        require oi4idp::params
		#include openjdkjava
		
		package { "wget":
        ensure => 'installed',
    }
		package { "apacheds":
			ensure => present,
		}
		
		
		#package { "oi4-bas":
		#	ensure => installed,
		#}
        $idp_rpm="${oi4idp::params::idp_rpm}"
		
		package { "oi4-idp":
                ensure => installed,
        }
		
        #package { ["${$idp_rpm}"]:
        #        ensure => installed,
        #} 
}
	
	
	

