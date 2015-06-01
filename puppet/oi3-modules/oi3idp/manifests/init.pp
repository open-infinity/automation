/*class oi3idp {
	exec { "Selfsigned certificate for Idp":
		path => "/usr/bin:/bin",
		command => "/etc/puppet/modules/oi3idp/files/create_certs.sh to.be.configured /opt/shibboleth-idp password",
		creates => "/opt/shibboleth-idp/credentials/idp.jks",
	}
}
*/

package { ["java-1.7.0-openjdk", "oi3-jetty"]:
	ensure => present,
	require => Class["oi3-basic"],
}

