class oi4-serviceplatform::install {
package { ["java-1.8.0-openjdk", "oi4-serviceplatform", "oi4-bas"]:
	ensure => present,
	require => Class['oi4-activiti-rdbms'],
}

}
