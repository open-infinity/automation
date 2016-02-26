class profiles::idp {
	require profiles::bas
  class {'oi4idp': 
  }
  #class {'oi4idp::install': 
  #}->
  #class {'oi4idp::config':
  #}
}
