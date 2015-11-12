class oi4-serviceplatform::install {
package { ["java-1.8.0-openjdk", "oi4-serviceplatform"]:
	ensure => present
}

if ! defined(Package['oi4-bas']) {
    package { 'oi4-bas': ensure => present }
}

}
