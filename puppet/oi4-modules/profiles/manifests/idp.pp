class profiles::idp {
  class {'apacheds::install': 
  }->
  class {'oi4idp::install': 
  }->
  class {'oi4idp::config':
  }
}
