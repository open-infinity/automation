class oi3idp {
	exec { "Selfsigned certificate for Idp":
		path => "/usr/bin:/bin",
		command => "/etc/puppet/modules/oi3idp/files/create_certs.sh to.be.configured /opt/shibboleth-idp password",
		creates => "/opt/shibboleth-idp/credentials/idp.jks",
	}
}
