class oi4apacheds::install{
	package { ["java-1.8.0-openjdk"]:
		ensure => present
	}
	package { "apacheds":
        	ensure => installed,
        }
}
	
	
	

