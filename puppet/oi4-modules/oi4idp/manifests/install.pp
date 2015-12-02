class oi4idp::install{
	
        #package { ["java-1.7.0-openjdk"]:
        	#ensure => present,
                #TODO maybe needed for logrotate ect
	        #require => Class["oi4-basic"],
        
	#}
        require oi4idp::params
		#include openjdkjava
		
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
	
	
	

