class oi3idp::install{
	
        #package { ["java-1.7.0-openjdk"]:
        	#ensure => present,
                #TODO maybe needed for logrotate ect
	        #require => Class["oi3-basic"],
        
	#}
        require oi3idp::params
        include openjdkjava

        $idp_rpm="${oi3idp::params::idp_rpm}"

        package { ["${$idp_rpm}"]:
                ensure => installed,
        } 
	
}
