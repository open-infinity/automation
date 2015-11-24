class oi4idp {
		notify {"at oi4idp, starging oi4idp install":}
		#include profiles::base
        #include oi4idp::install
        #include oi4idp::config
		class {'oi4idp::install':
		}->
		class {'oi4idp::config':
		}
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
