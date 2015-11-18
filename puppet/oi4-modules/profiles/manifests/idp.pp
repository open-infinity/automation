class profiles::idp {
  class {'idp::install': 
  }->
  class {'idp::config':
  }->
  class {'idp::service':
  }
}
