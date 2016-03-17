class oi4apacheds::install{
	if ! defined(Package['java-1.8.0-openjdk']) {
		package { ["java-1.8.0-openjdk"]:
			ensure => present
		}
	}
	
	package { "apacheds":
        	ensure => installed,
        }
}
	
	
	

