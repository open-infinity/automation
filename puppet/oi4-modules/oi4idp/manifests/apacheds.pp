class apacheds{
}

class apacheds::install{
        require oi4idp::params

        $apacheds_rpm="${oi4idp::params::apacheds_rpm}"
		
        package { ["${$apacheds_rpm}"]:
                ensure => installed,
        } 
}
