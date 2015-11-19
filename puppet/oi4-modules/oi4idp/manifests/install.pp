class oi4idp::install{
	
        #package { ["java-1.7.0-openjdk"]:
        	#ensure => present,
                #TODO maybe needed for logrotate ect
	        #require => Class["oi4-basic"],
        
	#}
        require oi4idp::params
        include openjdkjava

        $idp_rpm="${oi4idp::params::idp_rpm}"

        package { ["${$idp_rpm}"]:
                ensure => installed,
        } 
}

class apacheds::install{
        require oi4idp::params
        include openjdkjava

        $apacheds_rpm="${oi4idp::params::apacheds_rpm}"

        package { ["${$apacheds_rpm}"]:
                ensure => installed,
        } 
}

	
	
	

