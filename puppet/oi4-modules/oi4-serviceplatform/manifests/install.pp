class oi4-serviceplatform::install {
#	case $operatingsystem {
#'RedHat', 'CentOS': {
#$javaPackageName = 'java-1.7.0-openjdk'
#}
#'Ubuntu': {
#$javaPackageName = 'openjdk-7-jdk'
#}
#default: { fail("Unsupported operating system") }
#}
#package { ["java-1.7.0-openjdk", "oi4-serviceplatform", "oi4-bas"]:

package { ["java-1.8.0-openjdk", "oi4-serviceplatform", "oi4-bas"]:
	ensure => present,4
	require => Class["oi4-basic"],
}

}
