
class oi3httpd_lb_shibboleth inherits oi3variables  {
	require oi3-basic
	require oi3httpd
    if $::use_sp {
		require oi3httpd_shibboleth::install
		require oi3httpd_shibboleth::config
	}
	if $::user_loadbalancer {
		require oi3httpd_lb::config
	}
}

