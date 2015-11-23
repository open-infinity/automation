class oi4idp {
		notice {at oi4idp, starging apacheds install:}
		#include apacheds::install
        notice {at oi4idp, intall done starging install:}
		include oi4idp::install
        include oi4idp::config
}
/*
ensure_resource('package', 'java-1.7.0-openjdk', {
                ensure => present,
        })

        ensure_resource('package', 'java-1.7.0-openjdk-devel', {
                ensure => present,
        })

        package { "oi4-idp":
                ensure => present,
        }
*/
