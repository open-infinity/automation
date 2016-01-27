
#
# Service Provider configuration for httpd
#

class oi4httpd_sp  {
	require oi4httpd::service
	require oi4httpd_sp::install
	require oi4httpd_sp::config
	require oi4httpd_sp::service
}


class oi4httpd_sp::install inherits oi4variables {
    package { "shibboleth":
        ensure => '2.5.5-3.1.el6',
        require => Package["$apachePackageName"],
    }
}

class oi4httpd_sp::config inherits oi4variables {
    # Service Provider (Shibboleth)
	file {"/etc/shibboleth":
        ensure => directory,
        owner => 'apache',
        group => 'apache',
        mode => 777,
    }
    file { "${apacheConfPath}oi4-shibboleth.conf":
        source => "puppet:///modules/oi4httpd_sp/oi4-shibboleth.conf",
        replace => true,
        owner => "root",
        group => "root",
        mode => 0644,
        notify => Service["$apacheServiceName"],
        require => Package[$apachePackageName],
    }
	file { "${apacheConfPath}shib.conf":
        source => "puppet:///modules/oi4httpd_sp/shib.conf",
        replace => true,
        owner => "root",
        group => "root",
        mode => 0644,
        notify => Service["$apacheServiceName"],
        require => Package[$apachePackageName],
    }

    file { "${apacheConfPath}oi4-shibboleth-proxy.conf":
        source => "puppet:///modules/oi4httpd_sp/oi4-shibboleth-proxy.conf",
        replace => true,
        owner => "root",
        group => "root",
        mode => 0644,
        notify => Service["$apacheServiceName"],
        require => Package[$apachePackageName],
    }

		file {"/etc/sysconfig/shibd":
        source => "puppet:///modules/oi4httpd_sp/shibd.conf",
        replace => true,
        owner => 'root',
        group => 'root',
        mode => 644,
    }
		
	$shibboleth_idp_entityid_url=hiera('toas::sp::shibboleth_entity_url')
    $shibboleth_sp_entityid_url=hiera('toas::sp::shibboleth_sp_entityid_url')
    $shibboleth_idp_hostname=hiera('toas::sp::shibboleth_idp_hostname')
    
    #$sp_root_rsa_key_public=hiera('toas::sp::sp_root_rsa_key_public')
    #$httpd_domain_name=hiera('toas::sp::httpd_domain_name')
    $shibboleth_sp_id=hiera('toas::sp::shibboleth_sp_id')
    $shibboleth_sp_metadata_url=hiera('toas::sp::shibboleth_sp_metadata_url')
		
    file { "/etc/shibboleth/shibboleth2.xml":
        content => template("oi4httpd_sp/sp/shibboleth2.xml.erb"),
        replace => true,
        owner => "apache",
        group => "apache",
        mode => 777,
        notify => Service["$apacheServiceName"],
        require => Package["shibboleth"],
    }

    file { "/etc/shibboleth/attribute-map.xml":
        content => template("oi4httpd_sp/sp/attribute-map.xml.erb"),
        replace => true,
        owner => "root",
        group => "root",
        mode => 0644,
        notify => Service["$apacheServiceName"],
        require => Package["shibboleth"],
    }

    file {"/opt/openinfinity/common/shibboleth-sp":
        ensure => directory,
        owner => 'root',
        group => 'root',
        mode => 640,
        require => File["/opt/openinfinity/common"],
    }
    
    file { "/opt/openinfinity/common/shibboleth-sp/configure-sp.sh":
        content => template("oi4httpd_sp/sp/configure-sp.sh.erb"),
        replace => true,
        owner => "root",
        group => "root",
        mode => 0744,
        require => File["/opt/openinfinity/common/shibboleth-sp"],
    }

    exec { "configure-sp.sh":
        command => "/opt/openinfinity/common/shibboleth-sp/configure-sp.sh",
        user => "root",
        timeout => "3600",
        logoutput => true,
        require => [ 
            File["/opt/openinfinity/common/shibboleth-sp/configure-sp.sh"], 
            Package["shibboleth"],
            File["/root/.ssh/id_rsa"]
        ],
    }

    file {"/root/.ssh":
        ensure => directory,
        owner => 'root',
        group => 'root',
        mode => 700,
    }

	$sp_root_rsa_key_public=hiera('toas::sp::sp_root_rsa_key_public')
	$httpd_domain_name=hiera('toas::sp::httpd_domain_name')
	$sp_root_rsa_key_private=hiera('toas::sp::sp_root_rsa_key_private')
	#$sp_root_rsa_key_private = PSON.parse(hiera('toas::sp::sp_root_rsa_key_private'))
	
    # RSA key for accessing IdP machine
    file {"/root/.ssh/id_rsa":
        content => template("oi4httpd_sp/sp/root-id_rsa.erb"),
        replace => true,
        owner => 'root',
        group => 'root',
        mode => 600,
        require => File["/root/.ssh"],
    }

    # RSA key for accessing IdP machine
    file {"/root/.ssh/id_rsa.pub":
        content => template("oi4httpd_sp/sp/root-id_rsa.pub.erb"),
        replace => true,
        owner => 'root',
        group => 'root',
        mode => 600,
        require => File["/root/.ssh"],
    }

    file { "/opt/openinfinity/common/shibboleth-sp/post-configure-sp.sh":
        content => template("oi4httpd_sp/sp/post-configure-sp.sh.erb"),
        replace => true,
        owner => "root",
        group => "root",
        mode => 0744,
        require => File["/opt/openinfinity/common/shibboleth-sp"],
    }

    # This should be run after the configure phase and service (re)start
    exec { "post-configure-sp.sh":
        command => "/opt/openinfinity/common/shibboleth-sp/post-configure-sp.sh",
        user => "root",	
        timeout => "3600",
        logoutput => true,
        require => [ 
            File["/opt/openinfinity/common/shibboleth-sp/post-configure-sp.sh"], 
            Service["shibd"],
        ],
    }
}

class oi4httpd_sp::service inherits oi4variables {
    service { "shibd":
        ensure => running,
        enable => true,
        require => [
            Package["shibboleth"],
            Exec["configure-sp.sh"],
        ]
    }
}

