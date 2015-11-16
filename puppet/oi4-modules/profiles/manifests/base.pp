class profiles::base {
  $oi_home = hiera('toas::oi_home', '/opt/openinfinity')

  
  file {"/opt":
    ensure => directory,
    owner  => "root",
    group  => "root",
    mode   => 755,
  }

  file {"/opt/data":
    ensure => directory,
	owner => 'root',
	group => 'root',
	mode => 777,
  }
  
  file {"$oi_home":
    ensure  => directory,
    owner   => 'oiuser',
    group   => 'oiuser',
    mode    => 644,
    require => [User["oiuser"], File["/opt"]],
  }

  file {"$oi_home/data":
    ensure  => directory,
    owner   => 'oiuser',
    group   => 'oiuser',
    mode    => 644,
    require => [User["oiuser"], File["$oi_home"]],
  }

  file {"$oi_home/log":
    ensure  => directory,
    owner   => 'oiuser',
    group   => 'oiuser',
    mode    => 644,
    require => [User["oiuser"], File["$oi_home"]],
  }

  file {"$oi_home/conf":
    ensure  => directory,
    owner   => 'oiuser',
    group   => 'oiuser',
    mode    => 644,
    require => [User["oiuser"], File["$oi_home"]],
  }

  file {"$oi_home/lib":
    ensure  => directory,
    owner   => 'oiuser',
    group   => 'oiuser',
    mode    => 644,
    require => [User["oiuser"], File["$oi_home"]],
  }

  file {"$oi_home/common":
    ensure  => directory,
    owner   => 'oiuser',
    group   => 'oiuser',
    mode    => 644,
    require => [User["oiuser"], File["$oi_home"]],
  }

  file {"/home/oiuser":
    ensure  => directory,
    owner   => 'oiuser',
    group   => 'oiuser',
    mode    => 750,
    require => [User['oiuser'],Group['oiuser']]
  }
  user { "oiuser":
    ensure     => present,
    comment    => "Open Infinity user",
    gid        => "oiuser",
    shell      => "/bin/bash",
    managehome => true,
    require    => Group["oiuser"],
  }

  group {"oiuser":
    ensure => present,
  }
  class {'selinux':
    mode => 'permissive'
  }
  class {'users': }
  class {'repos': }
}
