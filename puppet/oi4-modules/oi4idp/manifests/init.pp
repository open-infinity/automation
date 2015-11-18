class oi3idp {
		include apacheds::install
        include oi3idp::install
        include oi3idp::config
}
/*
ensure_resource('package', 'java-1.7.0-openjdk', {
                ensure => present,
        })

        ensure_resource('package', 'java-1.7.0-openjdk-devel', {
                ensure => present,
        })

        package { "oi3-idp":
                ensure => present,
        }
*/
