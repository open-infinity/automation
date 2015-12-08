class oi4bas::install {

    package { "oi4-bas":
        ensure => present,
		#require => Class["oi4-basic"],
    }
}
