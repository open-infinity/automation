class profiles::liferay {
  class {'idp::install': 
  }->
  class {'idp::config':
  }->
  class {'idp::service':
  }
}
