class oi3-oauth-rdbms::config ($toaspathversion = undef) {
  if $toaspathversion == undef {
    $_toaspathversion = $::toaspathversion
  }
  else {
    $_toaspathversion = $toaspathversion
  }
	# Directory for oauth schema files
	file { "/opt/openinfinity/$_toaspathversion/oauth":
		ensure => directory,
		group => "root",
		owner => "root",
		require => Class["oi3-rdbms::service"],
	}

	# Directory for oauth schema files
	file { "/opt/openinfinity/$_toaspathversion/oauth/dbschema":
		ensure => directory,
		group => "root",
		owner => "root",
		require => File["/opt/openinfinity/$_toaspathversion/oauth"],
	}

	# Oauth schema create scripts
	file { "/opt/openinfinity/$_toaspathversion/oauth/dbschema/oauth2-schema.sql":
                ensure => present,
                source => "puppet:///modules/oi3-oauth-rdbms/oauth2-schema.sql",
                owner => "root",
                group => "root",
	      require => Class["oi3-rdbms::service"],
                notify => Class["oi3-oauth-rdbms::service"],
        }
}

